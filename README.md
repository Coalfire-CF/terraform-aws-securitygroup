![Coalfire](coalfire_logo.png)

# AWS Security Group Terraform Module

## Description

This module creates an AWS security group with a network interface attachment to connect to an existing network interface.

## Dependencies

Any resources requiring security groups

## Resource List

- Security Group
- Network Interface Associations (optional)

## Deployment Steps

This module can be called as outlined below.

- Change directories to the `examples/simple` directory.
- From the `examples/simple` directory run `terraform init`.
- Ensure that the `tfvars/example.tfvars` variables are correct (especially the profile) or create a new tfvars file with the correct variables
- Run `terraform plan -var-file tfvars/examples.tfvars` (or the newly created file) to review the resources being created.
- If everything looks correct in the plan output, run `terraform apply -var-file tfvars/examples.tfvars`.

## Usage

The directory `examples/simple` shows a basic declaration and use of the module, whereas `examples/network-associations` demonstrates the module's ability to create associations between the security group and any network interfaces (when provided with a list of desired network interface ids).

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
| [aws_network_interface.interfaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | This overwrites the default generated description for the security group | `string` | `"Managed by Terraform"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | The list of rules for egress traffic. Required fields for each rule are 'protocol', 'from\_port', 'to\_port', and at least one of 'cidr\_blocks', 'ipv6\_cidr\_blocks', 'security\_groups', 'self', or 'prefix\_list\_sg'. Optional fields are 'description' and those not used from the previous list | <pre>list(object({<br>    protocol         = string<br>    from_port        = string<br>    to_port          = string<br>    cidr_blocks      = optional(list(string), [])<br>    ipv6_cidr_blocks = optional(list(string), [])<br>    prefix_list_ids  = optional(list(string), [])<br>    security_groups  = optional(list(string), [])<br>    self             = optional(bool)<br>    description      = optional(string, "Managed by Terraform")<br>  }))</pre> | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | The list of rules for ingress traffic. Required fields for each rule are 'protocol', 'from\_port', 'to\_port', and at least one of 'cidr\_blocks', 'ipv6\_cidr\_blocks', 'security\_groups', 'self', or 'prefix\_list\_sg'. Optional fields are 'description' and those not used from the previous list | <pre>list(object({<br>    protocol         = string<br>    from_port        = string<br>    to_port          = string<br>    cidr_blocks      = optional(list(string), [])<br>    ipv6_cidr_blocks = optional(list(string), [])<br>    prefix_list_ids  = optional(list(string), [])<br>    security_groups  = optional(list(string), [])<br>    self             = optional(bool)<br>    description      = optional(string, "Managed by Terraform")<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the created security group. Conflicts with 'sg\_name\_prefix' | `string` | `""` | no |
| <a name="input_network_interface_resource_associations"></a> [network\_interface\_resource\_associations](#input\_network\_interface\_resource\_associations) | The IDs of already existing network interfaces to be associated with the created security group. If used, do not declare sg in the creation of those resources | `list(string)` | `[]` | no |
| <a name="input_sg_name_prefix"></a> [sg\_name\_prefix](#input\_sg\_name\_prefix) | The prefix to be used while generating a unique name for the security group. Conflicts with 'sg\_name' | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the created security group | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that the security group will be associated with | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_associated_network_interfaces"></a> [associated\_network\_interfaces](#output\_associated\_network\_interfaces) | The ARNs of the network interfaces associated to the security group by this module |
| <a name="output_id"></a> [id](#output\_id) | The id of the created security group |
<!-- END_TF_DOCS -->

## Contributing

If you're interested in contributing to our projects, please review the [Contributing Guidelines](CONTRIBUTING.md). And send an email to [our team](contributing@coalfire.com) to receive a copy of our CLA and start the onboarding process.

## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
