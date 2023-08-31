provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "demo-server_2" {
    ami = "ami-0464f90f5928bccb8"
    instance_type = "t2.micro"
    key_name = "dpp"
    security_groups = [ "demo-securitygroup" ]
}

/*set inbound rule inside security to enable ssh connection*/
resource "aws_security_group" "demo-securitygroup" {
  name        = "demo-securitygroup"
  description = "SSH Access"
  
  /*ssh ipv4 setting*/
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
