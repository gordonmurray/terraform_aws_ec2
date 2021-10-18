data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Network interface
resource "aws_network_interface" "default" {
  subnet_id   = aws_subnet.subnet-1a.id
  private_ips = ["100.10.1.0"]

  tags = {
    Name = "terraform-webserver"
  }
}


# Create EC2 instance
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.pem-key.key_name

  tags = {
    Name = "terraform-webserver"
  }

  network_interface {
    network_interface_id = aws_network_interface.default.id
    device_index         = 0
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
    timeout     = "1m"
    port        = "22"
    host        = aws_instance.example.public_dns
  }

}
