#!/bin/bash
set -e

echo "[INFO] Starting GitHub Runner setup..." | tee /home/ubuntu/runner-setup.log

# Install dependencies
apt-get update -y >> /home/ubuntu/runner-setup.log
apt-get install -y curl tar jq >> /home/ubuntu/runner-setup.log

# Create runner directory
mkdir -p /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Download runner package
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz >> /home/ubuntu/runner-setup.log
tar xzf actions-runner.tar.gz >> /home/ubuntu/runner-setup.log

# Configure the runner (⚠️ Terraform injects ${runner_token})
./config.sh --unattended \
  --url https://github.com/orgs/awsdeployer \
  --token ${runner_token} \
  --labels ec2,org-runner >> /home/ubuntu/runner-setup.log

# Install as service
./svc.sh install >> /home/ubuntu/runner-setup.log
./svc.sh start >> /home/ubuntu/runner-setup.log

