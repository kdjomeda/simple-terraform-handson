resource "aws_instance" "capstone-single" {
  ami = "ami-085925f297f89fce1"
  instance_type = "t2.micro"
}
