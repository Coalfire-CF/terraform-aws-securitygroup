<div align="center">
<img src="coalfire_logo.png" width="200">

</div>

## ACE-AWS-SecurityGroup

## Dependencies

Any resources requiring security groups

## Resource List

Insert a high-level list of resources created as a part of this module. E.g.

- Security Group
- Network Interface Associations (optional)

## Code Updates

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

Terraform 1.5.x or higher.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_network_interface_sg_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface_sg_attachment) | resource |
| [aws_network_interface.interfaces](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/network_interface) | data |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the created security group. Conflicts with 'sg_name_prefix' | `string` | n/a | yes |
| <a name="input_sg_name_prefix"></a> [sg\_name\_prefix](#input\_sg\_name\_prefix) | The prefix to be used while generating a unique name for the security group. Conflicts with 'sg_name' | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the created security group | `map(string)` | n/a | no |
| <a name="input_description"></a> [description](#input\_description) | This overwrites the default generated description for the security group. | `string` | n/a | no |
| <a name="input_vpc_id"></a> [vpc_id](#input\_vpc\_id) | The ID of the VPC that the security group will be associated with. | `string` | Managed by Terraform | no |
| <a name="input_network_interface_resource_associations"></a> [network_interface_resource_associations](#input\_network\_interface\_resource\_associations) | The IDs of already existing network interfaces to be associated with the created security group. If used, do not declare the security group in the creation of those resources. | `list(string)` | n/a | no |
| <a name="input_ingress_rules"></a> [ingress_rules](#input\_ingress\_rules) | The list of rules for ingress traffic. Required fields for each rule are 'protocol', 'from_port', 'to_port', and at least one of 'cidr_blocks', 'ipv6_cidr_blocks', 'security_groups', 'self', or 'prefix_list_sg'. Optional fields are 'description' and those not used from the previous list. | `list(object(...))` _see Security Group Rules section below_ | n/a | no |
| <a name="input_egress_rules"></a> [egress_rules](#input\_egress\_rules) | The list of rules for egress traffic. Required fields for each rule are 'protocol', 'from_port', 'to_port', and at least one of 'cidr_blocks', 'ipv6_cidr_blocks', 'security_groups', 'self', or 'prefix_list_sg'. Optional fields are 'description' and those not used from the previous list. | `list(object(...))` _see Security Group Rules section below_ | n/a | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the created security group |
| <a name="output_associated_network_interfaces"></a> [associated\_network\_interfaces](#output\_associated\_network\_interfaces) | The ARNs of the network interfaces associated to the security group by this module |

## Security Group Rules

Both the `ingress_rules` and `egress_rules` input variables hold the same structure. When creating the list of rules objects, the code should resemble:

``` HCL
  ingress_rules = [{
    protocol    = "tcp"
    from_port   = "443"
    to_port     = "443"
    cidr_blocks = [aws_vpc.main.cidr_block]
    },
    {
      # ssh
      protocol    = "tcp"
      from_port   = "22"
      to_port     = "22"
      cidr_blocks = [aws_vpc.main.cidr_block]
  }]

  egress_rules = [{
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
    cidr_blocks = ["0.0.0.0/0"]
  }]
```
The arguments accepted by both `ingress_rules` and `egress_rules` are also identical and are as follows:

| Name | Type | Required |
|------|------|:--------:|
| <a name="input_protocol"></a> [protocol](#input\_protocol) | `string` | yes |
| <a name="input_from_port"></a> [from_port](#input\_from\_port) | `string` | yes |
| <a name="input_to_port"></a> [to_port](#input\_to\_port) | `string` | yes |
| <a name="input_cidr_blocks"></a> [cidr_blocks](#input\_cidr\_blocks) | `list(string)` | no |
| <a name="input_ipv6_cidr_blocks"></a> [ipv6_cidr_blocks](#input\_ipv6\_cidr\_blocks) | `list(string)` | no |
| <a name="input_prefix_list_ids"></a> [prefix_list_ids](#input\_prefix\_list\_ids) | `list(string)` | no |
| <a name="input_security_groups"></a> [security_groups](#input\_security\_groups) | `list(string)` | no |
| <a name="input_self"></a> [self](#input\_self) | `bool` | no |
| <a name="input_description"></a> [description](#input\_description) | `string` | no |

All ingress and egress variables follow the [official Terraform documentation on inline security group rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#ingress).


<!-- END_TF_DOCS -->

## Contributing

[Relative or absolute link to contributing.md](CONTRIBUTING.md)


## License

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/license/mit/)


## Coalfire Pages

[Absolute link to any relevant Coalfire Pages](https://coalfire.com/)

### Copyright

Copyright © 2023 Coalfire Systems Inc.
