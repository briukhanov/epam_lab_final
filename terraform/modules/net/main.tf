data "aws_availability_zones" "availability_zones" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${(var.tags)}_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.availability_zones.names[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "${(var.tags)}_public_subnet"
  }
}


resource "aws_internet_gateway" "vpc_internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${(var.tags)}_vpc_internet_gateway"
  }
}

##  public route table
resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.vpc_internet_gateway.id
  }
  tags = {
    Name = "${(var.tags)}_public_subnet_route_table"
  }
}

## default route table
resource "aws_default_route_table" "main_route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    Name = "${(var.tags)}_main_route_table"
  }
}

## associate public subnet with public route table
resource "aws_route_table_association" "public_subnet_route_table" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}


resource "aws_security_group" "web_security_group" {
  name        = "allow_http_ssh"
  description = "Allow HTTP,ssh inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${(var.tags)}_web_security_group"
  }
}

## create security group ingress rule for web
resource "aws_security_group_rule" "web_ingress" {
  count             = length(var.web_ports)
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = element(var.web_ports, count.index)
  to_port           = element(var.web_ports, count.index)
  security_group_id = aws_security_group.web_security_group.id
}
## create security group egress rule for web
resource "aws_security_group_rule" "web_egress" {

  type              = "egress"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.web_security_group.id
}
