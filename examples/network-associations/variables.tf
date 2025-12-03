variable "aws_region" {
  description = "The region where things will be deployed by default"
  type        = string
}

variable "profile" {
  description = "The name of the profile to get AWS credentials from"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix to be used for resource naming"
  type        = string
}

variable "vpc_cidr" {
  description = "The cidr block for the vpc created for testing the security group"
  type        = string
}

variable "subnet_cidr" {
  description = "The cidr block for the subnet created for testing the security group"
  type        = string
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}