resource "aws_instance" "ami_instance" {
  ami                     = data.aws_ami.ami.id
  instance_type           = "t3.small"
  tags                    = {
        Name              = "${var.COMPONENT}-ami"
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
      "cd shell-scripting/roboshop-project"
      "make ${var.COMPONENT}"
    ]
  }
}
