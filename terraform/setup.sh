#!/bin/bash
set -e

LOG_FILE="/home/ubuntu/runner-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1
exec 2>&1

echo "[INFO] Starting GitHub Runner setup..."

# Install dependencies
apt-get update -y
apt-get install -y curl tar jq

# Create runner directory
mkdir -p /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Download latest GitHub runner
LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r .tag_name)
curl -o actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/$${LATEST_VERSION}/actions-runner-linux-x64-$${LATEST_VERSION:1}.tar.gz"
tar xzf actions-runner.tar.gz

# Configure runner (must run as ubuntu user, not root)
sudo -u ubuntu ./config.sh --unattended \
  --url "https://github.com/orgs/awsdeployer" \
  --token ${runner_token} \
  --labels ec2,org-runner \
  --name "ec2-runner-$${HOSTNAME}" \
  --replace

# Install and start service
./svc.sh install
./svc.sh start

echo "[SUCCESS] GitHub Runner setup completed!"

