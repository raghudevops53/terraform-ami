resource "aws_instance" "ami_instance" {
  ami                     = data.aws_ami.ami.id
  instance_type           = "t3.small"
  vpc_security_group_ids  = [aws_security_group.allow-ssh.id]
  tags                    = {
        Name              = "${var.COMPONENT}-ami"
  }
}

resource "aws_security_group" "allow-ssh" {
  name                    = "allow-${var.COMPONENT}-ami-sg"
  description             = "allow-${var.COMPONENT}-ami-sg"

  ingress {
    description           = "SSH"
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }

  tags = {
    Name                  = "allow-${var.COMPONENT}-ami-sg"
  }
}


resource "null_resource" "provisioner" {
  provisioner "remote-exec" {
    connection {
      host              = aws_instance.ami_instance.public_ip
      user              = "root"
      password          = "DevOps321" // Hardcoding the username and password in code is the worst idea and it causes security breaches as well
    }
    inline = [
      "yum install make -y",
      "git clone https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps53/_git/shell-scripting",
      "cd shell-scripting/roboshop-project",
      "make ${var.COMPONENT}"
    ]
  }
}
