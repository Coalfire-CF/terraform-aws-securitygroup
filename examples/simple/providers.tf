provider "aws" {
  region            = var.aws_region
  profile           = var.profile
  use_fips_endpoint = true
}