# Lookup the most recent Amazon Linux 2 AMI matching this name pattern
data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"] # Match AMIs with this naming pattern
  }

  owners = ["amazon"] # Only consider AMIs owned by Amazon
}

## THIS CREATES A NEW VPC ##
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr # Create a VPC with CIDR from input variable
}

## THIS CREATES A NEW SUBNET ##
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id # Attach subnet to the newly created VPC
  cidr_block = var.subnet_cidr # Use subnet CIDR from input variable
}

## THIS CREATES A NEW INSTANCE ##
resource "aws_instance" "example" {
  instance_type          = "t2.micro"             # Instance type
  ami                    = data.aws_ami.ami.id    # Use the AMI ID found by the data lookup above
  subnet_id              = aws_subnet.main.id     # Launch instance in the created subnet
  vpc_security_group_ids = [module.example_sg.id] # Attach security group created by module

  tags = {
    type = "security-group-test-instance" # Tag for identification
  }
}

# Security Group module call configuration
module "example_sg" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-securitygroup" # Path to security group module
  name   = "security_group_module_example_simple"               # Name assigned inside the module
  tags   = local.global_tags
  vpc_id = aws_vpc.main.id # Associate SG with the created VPC

  ingress_rules = { # Ingress rules allowing inbound HTTPS and SSH traffic
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

  egress_rules = { # Egress rules allowing all outbound traffic
    "allow_all_egress" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0" # Allow all outbound traffic to anywhere
      description = "Allow all egress"
    }
  }
}