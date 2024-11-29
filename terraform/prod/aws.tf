data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "docker_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = base64encode(file("docker.sh"))

  key_name = "super-pem"

  tags = {
    Name = "aws-docker-server"
  }
}
