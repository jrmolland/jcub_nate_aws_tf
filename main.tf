provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main_vpc"
    Environment = var.environment
    Terraform = "true"
  }

  enable_dns_hostnames = true
}

# Create Subnets
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Public Subnet"
  }
}

# Create SSH Key Pairs for Bastion and App Host EC2 instances

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCvdSYyLxrGkIJQAbYHSqiAweiU1TdMdUvdbmjisWFRK71JDlabQiv68wicA1iN/pB/7gStFsqqOXjyBu8NTNXYd+ZYy473VZwJJmmlR/dECiaNPqt6tlEoWmvnesMpx/RvK2gV23JHWzf9H5H4SSd1yBFSB2zGHgYmYQX5PO10cVu4qL5cVO5914c0dtYQuT0qr5MdlcN9laSfOFfI+PplTTUw1d2iy8Toig5+GXc3I8ffpOwXIsORiUsaTKRSSxvur0DwWWExxoWGC0xuN6zrGikHo2ekTFFg6Jmg45wjSlsFd6xLR1hYKW62qBauYsBe9Qor9OSOvtWSylh1fU2i3YU7GfdZY+TFjoChjskUOR0KfRsOgB9bQKSqHYQckfqnMSHIrWfO2GCVA9yUNcyJWSRLYdtZKa7MfAmLDaqyCsBRgUPLeZQ2/QXV7mtUNGDSG7bNUjikcSP4FJ08yDbLuYw5/ZfLc+h9oDpb7o1ubPjjBzbyjilelFvhla/jCP729l+zWs7VZT85GnOyFn0dVKQu+DuT//kpQFDQHoyoBGy4MDZOZoqqqm60C444vyNoD1FwElvLBXf5WBUbQ74vzQONSfskkV6y3CiEITbbAdFZBYE1xaih/fraDOK7u90QzdV2XQOcNBTnsxzOCPXLeIl1ijLcjtjcg519LGxdGQ== jcub@jcub"
}

resource "aws_key_pair" "app_host_key" {
  key_name   = "app_host_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiB8yHK/zSTolHBSzL6ZI2dYRQGwWWG+wysZ4J46/LFe3W8Zm5E5n45096e+Kggsz4MDpWg9Od+r4mPbjsQeMGzc9a+GZRMcTSD07kBqRQiDswiH/YIjWsK9FwrIiMBvzHtdvmhzCOkafJGaJiScl/YtRfrAzaTerbZPj6adsDohvhVUTMeto3E3/mtjoMMnstknphbRBUkmjJAAKIMB8FnfQEeooaffIJlvtQvdN5/UpTUgu2+O4NSP1L+2wLXxbs8SWs+CY2ZhKOvb0zYMXaGXLeXAt0EV+wDkbqTu8PaPXuM7kgGuot5F+NepF5q/vTdc8wjSn+SVr7IT5BckwGMQSQsP2/AllsFv5USqFqs9bz8BvVH16Oi3pJEn+znh9AV063lL2MMDYh8F3MzuDqqKoybxwx8Q/62hEKjJcL/yw/yoagUSNOmRROEzs6Nga194ymGpi8CZrpjjZ71zsURhHRggoeYMSMB6IKlZGmIJ4nldZLPzLj6u9dpBOiLraLSCZEsi5uXZ7RxGI7A5r1fuqfSF6JiwUWGjJ3bnkouhn0G6OXALMPBHsZvJc6nRgFO0s8q6tlI4C91JE4RP12k202YL6CgMU55Q6uLkLC17Jh9zf9naNLGSJ0oBSoSf/DENRfZ2v2B/rtf7MF+9icvkA/AJk1NKi21B31ChPq6w== jcub@jcub"
}

# Create App Host EC2 and Bastion Host EC2 instances
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name      = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "app_host" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.app_host_sg.id]
  key_name = aws_key_pair.app_host_key.key_name

  tags = {
    Name = "Vulnerable App Host"
  }
}

## Assign EIP to the Bastion Host EC2
resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion_host.id
}

# Create IGW for Internet access
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Main IGW"
  }
}

# Create EIP for NAT Gateway and the NAT Gateway itself
resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NAT Gateway"
  }
}

# Create Route Tables for subnets
resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}

resource "aws_route_table_association" "pub_sub_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table" "priv_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "Private Subnet Route Table"
  }
}

resource "aws_route_table_association" "priv_sub_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.priv_route_table.id
}

# Configure security groups for bastion host (public subnet) and EC2 App Host instance (private subnet)

resource "aws_security_group" "bastion_sg" {
  name   = "bastion_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allow trusted IP(s) access to the Bastion Host EC2 in the public subnet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.trusted_ips
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Bastion Host SG"
  }
}

resource "aws_security_group" "app_host_sg" {
  name   = "app_host_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "Allow ONLY the Bastion Host EC2 to access the private subnet via SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion_host.private_ip}/32"]
  }

  egress {
    description = "Allow all outbound traffic from the App Host EC2 instance"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "App Host SG"
  }
}