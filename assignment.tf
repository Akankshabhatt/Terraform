provider "aws" {
  region = "ap-south-1"
  profile = "akansha"
}

variable "enter_key_name" {
 type = string
 default = "key1"
}

resource "aws_instance" "os" {
  ami = "ami-010aff33ed5661202"
  instance_type = "t2.micro"
  key_name = var.enter_key_name
  security_groups = ["${aws_security_group.allow_http.name}"]
}

resource "aws_security_group" "allow_http" {
  name = "allow_httpd"
  description = "Allow port 80"
  vpc_id = "vpc-26839e4e"

ingress {
  description = "SSH"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }

tags = {
  Name = "allow_http"
 }
}

connection {
  type = "ssh"
  user = "ec2-user"
  private_key = file("C:\Users\HARSH\Downloads\key1.pem")
  host = aws_instance.os.public_ip
}

provisioner "remote-exec" {
  inline = [
   "sudo yum install httpd php git -y",
   "sudo systemctl restart httpd",
   "sudo systemctl enable httpd",
  ] 
}

#run the following commands to execute the terraform file
#terraform init
#terraform plan
#terraform apply

