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
  db_name_encrypted = "${terraform.workspace}-db-encrypted"
  db_name_unencrypted = "${terraform.workspace}-db-unencrypted"
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

# EC2 Instance with unencrypted root EBS volume
resource "aws_instance" "test-server-unencrypted" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = false
    delete_on_termination = true
  }

  tags = {
    Name = local.instance_name_unencrypted
    Type = "unencrypted-root-volume"
  }
}

# RDS Instance with encrypted storage
resource "aws_db_instance" "test-db-encrypted" {
  identifier = local.db_name_encrypted
  
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    Name = local.db_name_encrypted
    Type = "encrypted-storage"
  }
}

# RDS Instance with unencrypted storage
resource "aws_db_instance" "test-db-unencrypted" {
  identifier = local.db_name_unencrypted
  
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp3"
  storage_encrypted = false
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    Name = local.db_name_unencrypted
    Type = "unencrypted-storage"
  }
}
