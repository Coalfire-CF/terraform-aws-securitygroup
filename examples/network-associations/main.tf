data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  owners = ["amazon"]
}

data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_prefix}.0.0/24"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "${var.vpc_cidr_prefix}.0.0/24"
}

resource "aws_instance" "instance1" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.ami.id

  subnet_id = aws_subnet.main.id

  tags = {
    type = "security-group-test-instance"
  }
}

resource "aws_instance" "instance2" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.ami.id

  subnet_id = aws_subnet.main.id

  tags = {
    type = "security-group-test-instance"
  }
}

resource "aws_instance" "instance3" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.ami.id

  subnet_id = aws_subnet.main.id

  vpc_security_group_ids = [module.example_sg.id]

  tags = {
    type = "security-group-test-instance"
  }
}

module "example_sg" {
  source = "../.."

  name = "security_group_module_example_sg"

  vpc_id = aws_vpc.main.id

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

  network_interface_resource_associations = [
    aws_instance.instance1.primary_network_interface_id,
    aws_instance.instance2.primary_network_interface_id
  ]
}