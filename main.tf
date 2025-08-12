terraform { 
  cloud { 
    
    organization = "greed-island" 

    workspaces { 
      name = "sentinel-x-sentinel" 
    } 
  } 
}

locals {
  instance_name_encrypted = "${terraform.workspace}-instance-encrypted"
  instance_name_unencrypted = "${terraform.workspace}-instance-unencrypted"
}

provider "aws" {
  region = var.region
}

# EC2 Instance with encrypted root EBS volume
resource "aws_instance" "test-server-encrypted" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
    delete_on_termination = true
  }

  tags = {
    Name = local.instance_name_encrypted
    Type = "encrypted-root-volume"
  }
}
