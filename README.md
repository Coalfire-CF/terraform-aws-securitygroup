![Coalfire](coalfire_logo.png)

# terraform-aws-securitygroup

## Description

The AWS Security Group module creates:
1. A standard AWS security group 
2. An AWS security group configured with a network interface attachment to connect to an existing network interface

## Dependencies

The following modules should already have been applied and configured prior to the deployment steps:

- AWS Account Setup: https://github.com/Coalfire-CF/terraform-aws-account-setup

- VPC: https://github.com/Coalfire-CF/terraform-aws-vpc-nfw

- Any resources requiring security groups

## Resource List

- Security Group with ingress and egress rules
- Network Interface Associations (optional)

## Usage

Simple main.tf example: 

```hcl
module "example_sg" {
  source = "github.com/Coalfire-CF/terraform-aws-securitygroup?ref=v1.0.1"  # Path to security group module
  name   = "security_group_module_example_simple"                           # Name assigned inside the module
  tags   = local.global_tags
  vpc_id = aws_vpc.main.id     # Associate SG with the created VPC

  ingress_rules = {            # Ingress rules allowing inbound HTTPS and SSH traffic
    "allow_https" = {
      ip_protocol = "tcp"
      from_port   = "443"
      to_port     = "443"
      cidr_ipv4   = aws_vpc.main.cidr_block   # Allow HTTPS from within the VPC CIDR
    }
    "allow_ssh" = {
      ip_protocol = "tcp"
      from_port   = "22"
      to_port     = "22"
      cidr_ipv4   = aws_vpc.main.cidr_block   # Allow SSH from within the VPC CIDR
    }
  }

  egress_rules = {                            # Egress rules allowing all outbound traffic
    "allow_all_egress" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"               # Allow all outbound traffic to anywhere
      description = "Allow all egress"
    }
  }
}
```

Network Association main.tf example: 

```hcl
module "example_sg" {
  source = "github.com/Coalfire-CF/terraform-aws-securitygroup?ref=v1.0.1"  # Path to security group module
  name   = "security_group_module_example_network_assoc"                    # Name assigned inside the module
  vpc_id = aws_vpc.main.id                                                  # Associate SG with the created VPC
  tags   = local.global_tags

  ingress_rules = {                         # Ingress rules allowing inbound HTTPS and SSH traffic
    "allow_https" = {
      ip_protocol = "tcp"
      from_port   = "443"
      to_port     = "443"
      cidr_ipv4   = aws_vpc.main.cidr_block # Allow HTTPS from within the VPC CIDR
    }
    "allow_ssh" = {
      ip_protocol = "tcp"
      from_port   = "22"
      to_port     = "22"
      cidr_ipv4   = aws_vpc.main.cidr_block # Allow SSH from within the VPC CIDR
    }
  }

  egress_rules = {                          # Egress rules allowing all outbound traffic
    "allow_all_egress" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"             # Allow all outbound traffic to anywhere
      description = "Allow all egress"
    }
  }

  network_interface_resource_associations = [
    aws_instance.instance1.primary_network_interface_id,
    aws_instance.instance2.primary_network_interface_id
  ]
}
```

## Environment Setup

Below you will find the required steps to establish a secure connection to the AWS cloud environment used for the build. 

```hcl
IAM user authentication:

- Download and install the AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Log into the AWS Console and create AWS CLI Credentials (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- Configure the named profile used for the project, such as 'aws configure --profile example-mgmt'

SSO-based authentication (via IAM Identity Center SSO):

- Login to the AWS IAM Identity Center console, select the permission set for MGMT, and select the 'Access Keys' link.
- Choose the 'IAM Identity Center credentials' method to get the SSO Start URL and SSO Region values.
- Run the setup command 'aws configure sso --profile example-mgmt' and follow the prompts.
- Verify you can run AWS commands successfully, for example 'aws s3 ls --profile example-mgmt'.
- Run 'export AWS_PROFILE=example-mgmt' in your terminal to use the specific profile and avoid having to use '--profile' option.
```

## Deployment

1. Navigate to the Terraform project and create a parent directory in the upper level code, for example:

    ```hcl
    ../aws/terraform/{REGION}/management-account/example
    ```

   If multi-account management plane:
    ```hcl
    ../aws/terraform/{REGION}/{ACCOUNT_TYPE}-mgmt-account/example
    ```

2. Create a new branch. The branch name should provide a high level overview of what you're working on. 

3. Create a properly defined main.tf file via the template found under 'Usage' while adjusting tfvars as needed. Note that many provided variables are outputs from other modules. Example parent directory:
   ```hcl
   ├── security_group/
   │   ├── README.md
   │   ├── example.auto.tfvars  
   │   ├── locals.tf
   │   ├── main.tf
   │   ├── outputs.tf
   │   ├── providers.tf
   │   ├── variables.tf
   │   ├── ...
   ```

4. Change directories to the `security_group` directory.

5. Ensure that the `prefix.auto.tfvars` variables are correct (especially the profile)

6. Customize code to meet requirements, e.g. add/remove inbound rules, add/remove outbound rules

7. From the `security_group` directory run, initialize the Terraform working directory:
   ```hcl
   terraform init
   ```

8. Standardized formatting in code:
   ```hcl
   terraform fmt
   ```

9. Optional: Ensure proper syntax and "spell check" your code:
   ```hcl
   terraform validate
   ```

10. Create an execution plan and verify everything looks correct:
    ```hcl
    terraform plan
    ```
   
11. Apply the configuration:
    ```hcl
    terraform apply
    ```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->

## Contributing

[Start Here](CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.