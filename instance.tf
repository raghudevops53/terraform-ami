resource "aws_instance" "ami_instance" {
  ami                     = data.aws_ami.ami.id
  instance_type           = "t3.small"
  tags                    = {
        Name              = "${var.COMPONENT}-ami"
  }
}

