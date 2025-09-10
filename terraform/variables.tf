variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-04f59c565deeb2199"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"
}

variable "runner_token" {
  description = "GitHub runner token"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}
