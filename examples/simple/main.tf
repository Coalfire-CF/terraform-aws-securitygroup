data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  owners = ["amazon"]
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.ami.id

  subnet_id = aws_subnet.main.id

  vpc_security_group_ids = [module.example_sg.id]

  tags = {
    type = "security-group-test-instance"
  }
}

module "example_sg" {
  source = "github.com/Coalfire-CF/terraform-aws-securitygroup"

  name = "security_group_module_example_sg"

  vpc_id = aws_vpc.main.id

  ingress_rules = {
    "allow_https" = {
      ip_protocol = "tcp"
      from_port   = "443"
      to_port     = "443"
      cidr_ipv4   = aws_vpc.main.cidr_block
    }
    "allow_ssh" = {
      protocol    = "tcp"
      from_port   = "22"
      to_port     = "22"
      cidr_blocks = [aws_vpc.main.cidr_block]
    }
  }

  egress_rules = {
    "allow_all_egress" = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all egress"
    }
  }
}
