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
  cluster_name_encrypted = "${terraform.workspace}-cluster-encrypted"
  cluster_name_unencrypted = "${terraform.workspace}-cluster-unencrypted"
  global_cluster_name_encrypted = "${terraform.workspace}-global-encrypted"
  global_cluster_name_unencrypted = "${terraform.workspace}-global-unencrypted"
  elasticsearch_domain_encrypted = "test-es-encrypted"
  elasticsearch_domain_unencrypted = "test-es-unencrypted"
}

provider "aws" {
  region = var.region
}

# Elasticsearch domain with encryption at rest enabled
resource "aws_elasticsearch_domain" "test-es-encrypted" {
  domain_name           = local.elasticsearch_domain_encrypted
  elasticsearch_version = "7.10"

  cluster_config {
    instance_type = "t3.small.elasticsearch"
    instance_count = 1
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  encrypt_at_rest {
    enabled = true
  }

  tags = {
    Name = local.elasticsearch_domain_encrypted
    Type = "encrypted-elasticsearch"
  }
}

# Elasticsearch domain with encryption at rest disabled
# resource "aws_elasticsearch_domain" "test-es-unencrypted" {
#   domain_name           = local.elasticsearch_domain_unencrypted
#   elasticsearch_version = "7.10"

#   cluster_config {
#     instance_type = "t3.small.elasticsearch"
#     instance_count = 1
#   }

#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }

#   encrypt_at_rest {
#     enabled = false
#   }

#   tags = {
#     Name = local.elasticsearch_domain_unencrypted
#     Type = "unencrypted-elasticsearch"
#   }
# }

# # EC2 Instance with encrypted root EBS volume
# resource "aws_instance" "test-server-encrypted" {
#   ami           = var.ami
#   instance_type = var.instance_type
# 
#   root_block_device {
#     volume_type = "gp3"
#     volume_size = 20
#     encrypted   = true
#     delete_on_termination = true
#   }
# 
#   tags = {
#     Name = local.instance_name_encrypted
#     Type = "encrypted-root-volume"
#   }
# }
# 
# # # EC2 Instance with unencrypted root EBS volume
# resource "aws_instance" "test-server-unencrypted" {
#   ami           = var.ami
#   instance_type = var.instance_type
# 
#   root_block_device {
#     volume_type = "gp3"
#     volume_size = 20
#     encrypted   = false
#     delete_on_termination = true
#   }
# 
#   tags = {
#     Name = local.instance_name_unencrypted
#     Type = "unencrypted-root-volume"
#   }
# }
# 
# # =============================================================================
# # RDS INSTANCES (Single instances)
# # =============================================================================
# 
# # RDS Instance with encrypted storage
# resource "aws_db_instance" "test-db-encrypted" {
#   identifier = local.db_name_encrypted
#   
#   engine         = var.db_engine
#   engine_version = var.db_engine_version
#   instance_class = var.db_instance_class
#   
#   allocated_storage = var.db_allocated_storage
#   storage_type      = "gp3"
#   storage_encrypted = true
#   
#   db_name  = var.db_name
#   username = var.db_username
#   password = var.db_password
#   
#   skip_final_snapshot = true
#   deletion_protection = false
#   
#   tags = {
#     Name = local.db_name_encrypted
#     Type = "encrypted-storage"
#   }
# }
# 
# # RDS Instance with unencrypted storage
# resource "aws_db_instance" "test-db-unencrypted" {
#   identifier = local.db_name_unencrypted
#   
#   engine         = var.db_engine
#   engine_version = var.db_engine_version
#   instance_class = var.db_instance_class
#   
#   allocated_storage = var.db_allocated_storage
#   storage_type      = "gp3"
#   storage_encrypted = false
#   
#   db_name  = var.db_name
#   username = var.db_username
#   password = var.db_password
#   
#   skip_final_snapshot = true
#   deletion_protection = false
#   
#   tags = {
#     Name = local.db_name_unencrypted
#     Type = "unencrypted-storage"
#   }
# }
# 
# # =============================================================================
# # RDS CLUSTERS (Aurora clusters)
# # =============================================================================
# 
# # RDS Cluster with encrypted storage
# resource "aws_rds_cluster" "test-cluster-encrypted" {
#   cluster_identifier = local.cluster_name_encrypted
#   
#   engine         = var.cluster_engine
#   engine_version = var.cluster_engine_version
#   
#   database_name   = var.db_name
#   master_username = var.db_username
#   master_password = var.db_password
#   
#   storage_encrypted = true
#   kms_key_id       = var.kms_key_id
#   
#   skip_final_snapshot = true
#   deletion_protection = false
#   
#   tags = {
#     Name = local.cluster_name_encrypted
#     Type = "encrypted-cluster"
#   }
# }
# 
# # RDS Cluster with unencrypted storage
# resource "aws_rds_cluster" "test-cluster-unencrypted" {
#   cluster_identifier = local.cluster_name_unencrypted
#   
#   engine         = var.cluster_engine
#   engine_version = var.cluster_engine_version
#   
#   database_name   = var.db_name
#   master_username = var.db_username
#   master_password = var.db_password
#   
#   storage_encrypted = false
#   
#   skip_final_snapshot = true
#   deletion_protection = false
#   
#   tags = {
#     Name = local.cluster_name_unencrypted
#     Type = "unencrypted-cluster"
#   }
# }
# 
# # =============================================================================
# # RDS CLUSTER INSTANCES (Aurora cluster members)
# # =============================================================================
# 
# # RDS Cluster Instance for encrypted cluster
# resource "aws_rds_cluster_instance" "test-cluster-instance-encrypted" {
#   identifier         = "${local.cluster_name_encrypted}-instance-1"
#   cluster_identifier = aws_rds_cluster.test-cluster-encrypted.cluster_identifier
#   
#   instance_class = var.cluster_instance_class
#   engine         = aws_rds_cluster.test-cluster-encrypted.engine
#   engine_version = aws_rds_cluster.test-cluster-encrypted.engine_version
#   
#   tags = {
#     Name = "${local.cluster_name_encrypted}-instance-1"
#     Type = "encrypted-cluster-instance"
#   }
# }
# 
# # RDS Cluster Instance for unencrypted cluster
# resource "aws_rds_cluster_instance" "test-cluster-instance-unencrypted" {
#   identifier         = "${local.cluster_name_unencrypted}-instance-1"
#   cluster_identifier = aws_rds_cluster.test-cluster-unencrypted.cluster_identifier
# 
#   instance_class = var.cluster_instance_class
#   engine         = aws_rds_cluster.test-cluster-unencrypted.engine
#   engine_version = aws_rds_cluster.test-cluster-unencrypted.engine_version
#   
#   tags = {
#     Name = "${local.cluster_name_unencrypted}-instance-1"
#     Type = "unencrypted-cluster-instance"
#   }
# }
# 
# # =============================================================================
# # RDS GLOBAL CLUSTERS (Multi-region Aurora)
# # =============================================================================
# 
# # RDS Global Cluster with encrypted storage
# resource "aws_rds_global_cluster" "test-global-cluster-encrypted" {
#   global_cluster_identifier = local.global_cluster_name_encrypted
#   
#   engine         = var.cluster_engine
#   engine_version = var.cluster_engine_version
#   
#   storage_encrypted = true
#   
#   tags = {
#     Name = local.global_cluster_name_encrypted
#     Type = "encrypted-global-cluster"
#   }
# }
# 
# # RDS Global Cluster with unencrypted storage
# resource "aws_rds_global_cluster" "test-global-cluster-unencrypted" {
#   global_cluster_identifier = local.global_cluster_name_unencrypted
#   
#   engine         = var.cluster_engine
#   engine_version = var.cluster_engine_version
#   
#   storage_encrypted = false
#   
#   tags = {
#     Name = local.global_cluster_name_unencrypted
#     Type = "unencrypted-global-cluster"
#   }
# }
