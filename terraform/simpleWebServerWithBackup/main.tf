locals {
  http  = "80"
  https = "443"
  ssh   = "22"
}

# VPC creation
resource "aws_vpc" "vpc-prod" {
  cidr_block = var.mainVPC

  tags = {
    "Name" = "vpc-prod"
  }
}

# Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-prod.id

  tags = {
    "Name" = "gw"
  }
}

# Route table
resource "aws_route_table" "route-table-prod" {
  vpc_id = aws_vpc.vpc-prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route-table-prod"
  }
}

# Subnet
resource "aws_subnet" "subnet-prod" {

  cidr_block        = var.prodSubnetCidr
  vpc_id            = aws_vpc.vpc-prod.id
  availability_zone = "eu-west-2a"

  tags = {
    "Name" = "subnet-prod"
  }

}

# Route table association 
resource "aws_route_table_association" "route-table-association-prod" {
  subnet_id      = aws_subnet.subnet-prod.id
  route_table_id = aws_route_table.route-table-prod.id
}

# Security Group
resource "aws_security_group" "allow-web-traffic-prod" {
  name        = "allow-web-traffic"
  description = "Allow inbound web traffic"
  vpc_id      = aws_vpc.vpc-prod.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = local.https
    to_port     = local.https
    protocol    = "tcp"
    cidr_blocks = var.allowPublicAccessCidr
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = local.http
    to_port     = local.http
    protocol    = "tcp"
    cidr_blocks = var.allowPublicAccessCidr
  }

  ingress {
    description = "SSH from VPC"
    from_port   = local.ssh
    to_port     = local.ssh
    protocol    = "tcp"
    cidr_blocks = var.allowPublicAccessCidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-web-traffic-prod"
  }
}

# Network Interface
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-prod.id
  security_groups = [aws_security_group.allow-web-traffic-prod.id]

}

# Elastic IP 
resource "aws_eip" "eip-prod" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = aws_network_interface.web-server-nic.private_ip

  depends_on = [aws_internet_gateway.gw]

}

# AWS instance
resource "aws_instance" "web-server" {

  ami = var.amis[var.region]

  instance_type     = "t2.micro"
  availability_zone = "eu-west-2a"

  key_name = "terraform-key"
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  provisioner "remote-exec" { # Advice is to NOT use this and to use "user_data" instead
    inline = [
      "sudo amazon-linux-extras install -y nginx1.12",
      "sudo bash -c 'echo Dude > /usr/share/nginx/html/index.html'",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.public_key_path)
      host        = self.public_ip
    }
  }
  tags = {
    "Name"     = "Web Server"
    "Snapshot" = "true"
  }
}

# Display the public IP address
output "public-ip" {

  value = aws_eip.eip-prod.public_ip

}
