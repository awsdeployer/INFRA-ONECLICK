variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-04f59c565deeb2199" # <-- you can hardcode here OR override via TF_VAR_ami_id
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

