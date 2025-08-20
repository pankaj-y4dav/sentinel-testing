terraform { 
  cloud { 
    
    organization = "greed-island" 

    workspaces { 
      name = "sentinel-x-sentinel" 
    } 
  } 
}

locals {
  db_name_unencrypted = "${terraform.workspace}-db-unencrypted"
}

provider "aws" {
  region = var.region
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
