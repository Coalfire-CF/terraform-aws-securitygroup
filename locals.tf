locals {
  use_prefix = var.sg_name_prefix != "" ? true : false

  internal_tags = {

    Managed-by = "Terraform"
    Module     = "terraform-aws-securitygroup"
  }
}