#!/bin/bash
set -e

ORG_NAME="awsdeployer"
RUNNER_NAME="ec2-runner-$(hostname)"
RUNNER_LABELS="ec2,terraform"
GITHUB_URL="https://github.com/$${ORG_NAME}"
RUNNER_DIR="/home/ubuntu/actions-runner"

LOG_FILE="$RUNNER_DIR/runner-setup.log"
mkdir -p "$RUNNER_DIR"
cd "$RUNNER_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[INFO] Starting GitHub Runner setup..."

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y curl tar jq

# Download latest GitHub runner
LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r .tag_name)
curl -o actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/$${LATEST_VERSION}/actions-runner-linux-x64-$${LATEST_VERSION:1}.tar.gz"
tar xzf ./actions-runner.tar.gz

# Configure runner using the short-lived token (Terraform injects it)
./config.sh --unattended \
  --url "$GITHUB_URL" \
  --token "${runner_token}" \
  --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" \
  --replace

# Install as service
sudo ./svc.sh install
sudo ./svc.sh start

echo "[SUCCESS] GitHub Runner setup completed!"

