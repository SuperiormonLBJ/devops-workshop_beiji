provider "aws" {
  // change to sinagpore
  region = "ap-southeast-1"
}

// only differentce from V3, is here to create multi instances, 3 instnaces, 
// ["jenkins-master", "build-slave", "ansible"] in 1 terraform command
resource "aws_instance" "demo-server_4" {
    // change here to match the ami type in aws, this is ubuntu for jenkins and ansible
    ami = "ami-0df7a207adb9748c7"
    instance_type = "t2.micro"
    key_name = "dpp"
    //security_groups = [ "demo-sg" ]   // here is only for create e2c
    vpc_security_group_ids = [aws_security_group.demo-sg.id] // security way in vpc
    // rightnow only call 1st subnet
    subnet_id = aws_subnet.dpp-public-subnet-01.id 
    // create 3 instances inside subnet01
    for_each = toset(["jenkins-master", "build-slave", "ansible"])
    tags = {
      Name = "${each.key}"
    }

}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.dpp-vpc.id 
  
  ingress {
    description      = "Shh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

// way to create vpc in aws
// resource type: aws_vpc,  resource name: dpp-vpc
// resource is = 'dpp-vpc' in tags
resource "aws_vpc" "dpp-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpp-vpc_2"
  }
  
}

resource "aws_subnet" "dpp-public-subnet-01" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  // change to sinagpore
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "dpp-public-subent-01"
  }
}

// 2nd subnet, can have many subnet inside 1 vpc
resource "aws_subnet" "dpp-public-subnet-02" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  // change to sinagpore b
  availability_zone = "ap-southeast-1b"
  tags = {
    Name = "dpp-public-subent-02"
  }
}

// internet gateway
resource "aws_internet_gateway" "dpp-igw" {
  vpc_id = aws_vpc.dpp-vpc.id 
  tags = {
    Name = "dpp-igw"
  } 
}

// route table
resource "aws_route_table" "dpp-public-rt" {
  vpc_id = aws_vpc.dpp-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpp-igw.id 
  }
}

resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
  subnet_id = aws_subnet.dpp-public-subnet-01.id
  route_table_id = aws_route_table.dpp-public-rt.id   
}

resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
  subnet_id = aws_subnet.dpp-public-subnet-02.id 
  route_table_id = aws_route_table.dpp-public-rt.id   
}
