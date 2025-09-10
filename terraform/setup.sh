#!/bin/bash
set -e

echo "[INFO] Starting GitHub Runner setup..."

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y curl tar jq git

# Create runner directory
mkdir -p /home/ubuntu/actions-runner
cd /home/ubuntu/actions-runner

# Download latest runner package
curl -o actions-runner.tar.gz -L https://github.com/actions/runner/releases/download/v2.328.0/actions-runner-linux-x64-2.328.0.tar.gz
tar xzf actions-runner.tar.gz
rm actions-runner.tar.gz

# Configure runner (expand token from Terraform variable)
sudo -u ubuntu ./config.sh --url https://github.com/orgs/awsdeployer --token $${runner_token} --unattended --replace

# Install as a service
./svc.sh install
./svc.sh start

echo "[INFO] GitHub Runner installation complete!"

