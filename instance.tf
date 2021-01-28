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
  // This is a little hack to run this resource every time.
  
  triggers = {
    abc = timestamp()
  }
  provisioner "remote-exec" {
    connection {
      host                = aws_instance.ami_instance.public_ip
      user                = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["SSH_USER"]
      password            = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["SSH_PASS"]
    }
    inline = [
      "sudo yum install ansible -y",
      "ansible-pull -i localhost, -U https://DevOps-Batches@dev.azure.com/DevOps-Batches/DevOps53/_git/ansible roboshop-project/roboshop.yml -e ENV=${var.ENV} -t ${var.COMPONENT} -e component=${var.COMPONENT} -e APP_ARTIFACT_VERSION=${var.APP_ARTIFACT_VERSION} -e PAT=${jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["PAT"]}"
    ]
  }
}

resource "aws_ami_from_instance" "ami" {
  depends_on              = [null_resource.provisioner]
  name                    = "${var.COMPONENT}-${var.APP_ARTIFACT_VERSION}"
  source_instance_id      = aws_instance.ami_instance.id
}