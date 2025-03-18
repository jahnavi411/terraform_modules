#create vpc
resource "aws_vpc" "terra_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "Terra VPC"
    }
}

#create public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id            = aws_vpc.terra_vpc.id
    cidr_block        = var.public_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = var.az
}


resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.terra_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true
}

#create private subnet
/*resource "aws_subnet" "private_subnet" {
    vpc_id            = aws_vpc.terra_vpc.id
    cidr_block        = var.private_subnet_cidr
    availability_zone = var.az
}*/

#create igw
resource "aws_internet_gateway" "terra_igw" {
    vpc_id = aws_vpc.terra_vpc.id
}

#route table for public subnet
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.terra_vpc.id
    route {
        cidr_block = var.allow_all
        gateway_id = aws_internet_gateway.terra_igw.id
  }
}

#route table association for public subnet
resource "aws_route_table_association" "public_assoc" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
    subnet_id      = aws_subnet.public_2.id
    route_table_id = aws_route_table.public_rt.id
}

#create eip
/*resource "aws_eip" "nat_eip" {
    domain = "vpc"
    depends_on = [aws_internet_gateway.terra_igw]
}*/

#craete nat gateway
/*resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet.id
}*/

#create route table for private subnet
/*resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = var.allow_all
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

#route table association for private subnet
resource "aws_route_table_association" "private_assoc" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
}*/

#security group for load balancer
resource "aws_security_group" "alb_sg" {
    vpc_id = aws_vpc.terra_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [var.allow_all]
    }
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        cidr_blocks = [var.allow_all]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.allow_all]
    }
}

#security group for ec2 instance
resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_vpc.terra_vpc.id
    tags = {
        Name = "terra_sg"
    }
    ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = [var.allow_all]
      }
    ingress {
        description = "Allow PostgreSQL access from EC2 Security Group"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
       security_groups = [aws_security_group.alb_sg.id]  # Only allow EC2 instances to connect
    }
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = [var.allow_all]
        }
    depends_on = [aws_security_group.alb_sg]
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.terra_vpc.id  # ✅ Ensure this matches the VPC of your RDS instance
}