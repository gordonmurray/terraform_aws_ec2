data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create EC2 instance
resource "aws_instance" "example" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t3.micro"
  key_name                = aws_key_pair.pem-key.key_name
  subnet_id               = aws_subnet.subnet-1a.id
  vpc_security_group_ids  = [aws_security_group.example.id]
  disable_api_termination = true

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = "10"

    tags = {
      Name = "terraform-webserver"
    }
  }

  tags = {
    Name = "terraform-webserver"
  }

  provisioner "file" {
    // upload the index.html file
    source      = "files/index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install apache2-bin ssl-cert apache2 -y",
      "sudo mv /home/ubuntu/index.html /var/www/html/index.html"
    ]
  }

  connection {
    // connect over ssh
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
    port        = "22"
    host        = aws_instance.example.public_dns
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

}
