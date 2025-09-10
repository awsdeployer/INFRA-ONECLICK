#!/bin/bash

# === Install GitHub Runner ===
sudo apt-get update -y
sudo apt-get install -y curl tar jq

# Create runner directory
sudo mkdir -p /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Download and extract runner
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz
tar xzf ./actions-runner.tar.gz
rm actions-runner.tar.gz

echo "Runner token received: ${runner_token}" >> /var/log/user-data.log

sudo chown -R ubuntu:ubuntu /home/ubuntu/actions-runner

# Configure runner as ubuntu user
sudo -u ubuntu ./config.sh --unattended \
  --url https://github.com/awsdeployer \
  --token "${runner_token}" \
  --name org_runner \
  --work "_work" >> /var/log/runner-config.log 2>&1


sudo hostnamectl set-hostname master
sudo ./svc.sh install
sudo ./svc.sh start
# ===== Install Docker =====
sudo apt remove -y docker docker-engine docker.io containerd runc || true
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# ===== Initialize Kubernetes (kubeadm) =====
sudo kubeadm init --cri-socket=unix:///var/run/crio/crio.sock

# Configure kubeconfig for ubuntu
mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
export KUBECONFIG=/home/ubuntu/.kube/config

# Wait a few seconds to ensure kubectl can talk to API
sleep 10

# ===== Deploy Weave Net CNI =====
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# Untaint master so pods can run
kubectl taint node $(hostname) node-role.kubernetes.io/control-plane:NoSchedule- || true

# Wait for kube-system pods to be ready
echo "Waiting for kube-system pods..."
until kubectl get pods -n kube-system | grep -Ev 'STATUS|Running|Completed' | wc -l | grep -q '^0$'; do
    sleep 10
done

# ===== Kubernetes ingress & metrics =====
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# ===== Install Helm =====
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
export PATH=$PATH:/usr/local/bin

# ===== Install Prometheus & Grafana =====
kubectl create namespace monitoring || true
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/prometheus \
  --namespace monitoring \
  --set server.persistentVolume.enabled=false \
  --set server.resources.requests.cpu=0 \
  --set server.resources.requests.memory=0 \
  --set alertmanager.enabled=false \
  --set pushgateway.enabled=false \
  --set kubeStateMetrics.enabled=false \
  --set nodeExporter.enabled=false

kubectl patch svc prometheus-server -n monitoring -p '{"spec":{"type":"NodePort","ports":[{"name":"web","port":9090,"targetPort":9090,"nodePort":32000}]}}'

helm install grafana grafana/grafana -n monitoring \
  --set persistence.enabled=false \
  --set adminPassword='admin' \
  --set service.type=NodePort \
  --set service.nodePort=32001

NODE_IP=$(kubectl get nodes -o jsonpath="{.items[0].status.addresses[0].address}")
echo "Prometheus URL: http://$NODE_IP:32000"
echo "Grafana URL: http://$NODE_IP:32001"

