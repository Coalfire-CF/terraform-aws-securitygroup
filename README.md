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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_network_interface_sg_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_sg_attachment) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_network_interface.interfaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | This overwrites the default generated description for the security group | `string` | `"Managed by Terraform"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | The list of rules for egress traffic. Required fields for each rule are 'protocol', 'from\_port', 'to\_port', and at least one of 'cidr\_blocks', 'ipv6\_cidr\_blocks', 'security\_groups', 'self', or 'prefix\_list\_sg'. Optional fields are 'description' and those not used from the previous list | <pre>map(object({<br/>    cidr_ipv4                    = optional(string, null)<br/>    cidr_ipv6                    = optional(string, null)<br/>    description                  = optional(string, "Managed by Terraform")<br/>    from_port                    = optional(string, null)<br/>    ip_protocol                  = optional(string, null)<br/>    prefix_list_id               = optional(string, null)<br/>    referenced_security_group_id = optional(string, null)<br/>    to_port                      = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | The list of rules for ingress traffic. Required fields for each rule are 'protocol', 'from\_port', 'to\_port', and at least one of 'cidr\_blocks', 'ipv6\_cidr\_blocks', 'security\_groups', 'self', or 'prefix\_list\_sg'. Optional fields are 'description' and those not used from the previous list | <pre>map(object({<br/>    cidr_ipv4                    = optional(string, null)<br/>    cidr_ipv6                    = optional(string, null)<br/>    description                  = optional(string, "Managed by Terraform")<br/>    from_port                    = optional(string, null)<br/>    ip_protocol                  = optional(string, null)<br/>    prefix_list_id               = optional(string, null)<br/>    referenced_security_group_id = optional(string, null)<br/>    to_port                      = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the created security group. Conflicts with 'sg\_name\_prefix' | `string` | n/a | yes |
| <a name="input_network_interface_resource_associations"></a> [network\_interface\_resource\_associations](#input\_network\_interface\_resource\_associations) | The IDs of already existing network interfaces to be associated with the created security group. If used, do not declare sg in the creation of those resources | `list(string)` | `[]` | no |
| <a name="input_sg_name_prefix"></a> [sg\_name\_prefix](#input\_sg\_name\_prefix) | The prefix to be used while generating a unique name for the security group. Conflicts with 'sg\_name' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that the security group will be associated with | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_associated_network_interfaces"></a> [associated\_network\_interfaces](#output\_associated\_network\_interfaces) | The ARNs of the network interfaces associated to the security group by this module |
| <a name="output_id"></a> [id](#output\_id) | The id of the created security group |
<!-- END_TF_DOCS -->

## Contributing

[Start Here](CONTRIBUTING.md)

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

## Contact Us

[Coalfire](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.