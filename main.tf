data "aws_availability_zones" "azs" {}

resource "aws_security_group" "capstone-simple-secgroup" {
  name = "CapstoneSimpleSecgroup"
  description = "This is a simple security group for http and https access"
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow connection to http 80"
  }

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow connection to ssl port"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# This is just for introductory concepts. I would not do this for production or shared projects
resource "aws_key_pair" "capstone-key-pair" {
  key_name = "CapstoneIndentity.pem"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4cF7vD3LqmJrrwsRseh8NVdYv7qeRlvSVDHtinVmo8kUI7q8SvSGynqoZidRQzTbrnUEbnjnCOx+/6raQKMrtdQPGkAg3X5xUVUArvWjJ+Dy6GUmcK+GJZaF9fGiGO1Ep6dOVr6BlksbOZjHJDzLnJuJnSs4JgJFafw3scGVUV/8W4oQLq1DYaCMaqOgFkrcJPi0GbfEga9LLsQ+DWjOG+SpYscLc8ShVrEazro6BQMcWiwpQXS3hZ1C55bYtNNkY7//quTFj5BOHPGKT7IHTbYegjALf15Gk+d9UvTs2eWar8qY38XvRTmZD5CXwVYiY+9b5HiJJpKfK6wvnPJMo+PtQziX6u3P7uha+uXDXBESEZh8hFWv4sddtV/qCu+wN3C7d2mQXUAkDBcq0an3gZ/3lE5OVJP6mIT2PduuH4pKZwRPo3qxtkEgHIxfOj7ETMYdYIHeL0ZTc7ac6Yn7enXFqTV7mgOiiBymsC1Mko2X2nWB9tebuH2zXuYgL9YDrfo+AD1E0o4aTgfSozTcnYAVtg1e3SEsE5nbiKIxkN74YtmDiKjnjSMXE1H0+8n982U9WYnN9t1UpHoIubhwc4irEX0dbeUiKK6qovu+lVgWSYmUOHEJHvBfNXwIMxRivw6hmX/n5T7XyY75lkn+WiPLVIenVXX7+PngkguaptQ== capstone-identity"
}

resource "aws_instance" "capstone-single" {
  ami = "ami-085925f297f89fce1"
  instance_type = "t2.micro"
  count = 1
  security_groups = ["${aws_security_group.capstone-simple-secgroup.name}"]
  user_data = file("files/ubuntu_cloud_init.sh")
  key_name = aws_key_pair.capstone-key-pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "CapstonInstance"
    AZName = "CapstoneInstance-${element(data.aws_availability_zones.azs.names,count.index )}"
    Env  = "Test"
    Product = "Capstone"
    Terraform = true
  }
}
