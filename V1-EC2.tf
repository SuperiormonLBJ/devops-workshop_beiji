/*singapore region code "ap-southeast-1"*/
/*can only have 1 tf file when running terraform commands*/
provider "aws" {
  region = "ap-southeast-1"
}
/*instance name "demo-server", key pair = dpp.pem*/
/*ami code here is Amazon Linux[this need to check for each region]*/
resource "aws_instance" "demo-server" {
    ami = "ami-0464f90f5928bccb8"
    instance_type = "t2.micro"
    key_name = "dpp"
}
