variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.small"
}

variable "ami" {
  default = "ami-04b70fa74e45c3917"
}


variable "key_name" {
  default = "deployer-key"  # Update with your key pair name
}