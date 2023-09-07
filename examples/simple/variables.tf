variable "aws_region" {
  description = "The region where things will be deployed by default"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The name of the profile to get AWS credentials from"
  type        = string
}

variable "vpc_cidr_prefix" {
  description = "The cidr block for the vpc created for testing the security group"
  type        = string
  default     = "10.0"
}
