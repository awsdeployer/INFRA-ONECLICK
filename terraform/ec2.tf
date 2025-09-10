resource "aws_instance" "demo" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "ashwanthramnv"

  # Inject the runner_token variable into the script
  user_data = templatefile("${path.module}/setup.sh", {
    runner_token = var.runner_token
  })

  tags = {
    Name = "awsdeployer-org-runner"
  }
}

