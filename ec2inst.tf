resource "aws_instance" "web" {
  ami             = var.amiinst
  instance_type   = var.inst_type
  subnet_id       = aws_subnet.Publicsubnet1.id
  security_groups = [aws_security_group.newsec.id]
  key_name        = aws_key_pair.mynewkey.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = tls_private_key.privkey.private_key_pem
    port        = 22
  }

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
    on_failure  = fail
  }

  provisioner "local-exec" {
    command    = "echo ${self.private_ip} >> private_ips.txt"
    on_failure = continue
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }



  tags = {
    Name     = "HelloWorld"
    "tagnew" = var.itisourlistvar[0]
    "tagnew" = var.itisourlistvar[1]
    "tagnew" = var.itisourlistvar[2]
  }

}










resource "aws_eip" "lb" {
  instance   = aws_instance.web.id
  domain     = "vpc"
  depends_on = [aws_instance.web]
}


resource "aws_security_group" "newsec" {
  # ... other configuration ...
  # vpc_id = aws_vpc.newvpc.id // another way to write
  vpc_id = data.aws_vpc.selected.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  dynamic "ingress" {
    for_each = var.secingressrule
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = ingress.value
      cidr_blocks = ["0.0.0.0/0"]

    }
  }
}

resource "local_file" "foo" {
  content  = tls_private_key.privkey.private_key_pem
  filename = "ourkeymaterial"
}

resource "aws_key_pair" "mynewkey" {
  key_name   = "mynewkey"
  public_key = tls_private_key.privkey.public_key_openssh
}
resource "tls_private_key" "privkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



// extra inst to practice count


resource "aws_instance" "expcount" {
  ami           = var.amiinst
  instance_type = var.inst_type
  count         = (var.inst_count == 1) ? 1 : 0

}
// working with data sources

data "aws_vpc" "selected" {
  id = aws_vpc.newvpc.id
}
output "vpcidpr" {
  value     = aws_vpc.newvpc.id
  sensitive = true
}