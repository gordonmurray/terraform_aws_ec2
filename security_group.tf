resource "aws_security_group" "example" {
  name        = "example"
  description = "example security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "terraform-webserver"
  }
}
