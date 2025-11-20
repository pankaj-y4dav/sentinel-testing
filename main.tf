terraform {
  cloud {
    organization = "greed-island"

    workspaces {
      name = "sentinel-x-sentinel"
    }
  }
}

locals {
  instance_name_encrypted             = "test-instance-encrypted"
  instance_name_unencrypted           = "test-instance-unencrypted"
  db_name_encrypted                   = "test-db-encrypted"
  db_name_unencrypted                 = "test-db-unencrypted"
  cluster_name_encrypted              = "test-cluster-encrypted"
  cluster_name_unencrypted            = "test-cluster-unencrypted"
  global_cluster_name_encrypted       = "test-global-encrypted"
  global_cluster_name_unencrypted     = "test-global-unencrypted"
  elasticsearch_domain_encrypted      = "test-es-encrypted"
  elasticsearch_domain_unencrypted    = "test-es-unencrypted"
  redis_replication_group_encrypted   = "test-redis-replication-encrypted"
  redis_replication_group_unencrypted = "test-redis-replication-unencrypted"
  s3_bucket_encrypted                 = "test-s3-encrypted"
  s3_bucket_unencrypted               = "test-s3-unencrypted"

  # New locals for tag testing
  bucket_no_tags     = "test-bucket-no-tags"
  bucket_lowercase   = "test-bucket-lowercase"
  bucket_uppercase   = "test-bucket-uppercase"
  bucket_mixed_case  = "test-bucket-mixed-case"
  bucket_pascal_case = "test-bucket-pascal-case"
  bucket_snake_upper = "test-bucket-snake-upper"
  bucket_kebab_case  = "test-bucket-kebab-case"

  bucket_only_one_tag  = "test-bucket-only-one-tag"
  bucket_only_two_tags = "test-bucket-only-two-tags"
  bucket_wrong_tags    = "test-bucket-wrong-tags"
  bucket_partial_wrong = "test-bucket-partial-wrong"
}

provider "aws" {
  region = var.region
}

/*
  All resource blocks below have been commented out to focus on tag testing for Sentinel policies.
  If you need to re-enable any of them, remove the surrounding comment markers.

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
resource "aws_elasticsearch_domain" "test-es-unencrypted" {
  domain_name           = local.elasticsearch_domain_unencrypted
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
    enabled = false
  }

  tags = {
    Name = local.elasticsearch_domain_unencrypted
    Type = "unencrypted-elasticsearch"
  }
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

# =============================================================================
# RDS INSTANCES (Single instances)
# =============================================================================

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

# =============================================================================
# RDS CLUSTERS (Aurora clusters)
# =============================================================================

# RDS Cluster with encrypted storage
resource "aws_rds_cluster" "test-cluster-encrypted" {
  cluster_identifier = local.cluster_name_encrypted
  
  engine         = var.cluster_engine
  engine_version = var.cluster_engine_version
  
  database_name   = var.db_name
  master_username = var.db_username
  master_password = var.db_password
  
  storage_encrypted = true
  kms_key_id       = var.kms_key_id
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    Name = local.cluster_name_encrypted
    Type = "encrypted-cluster"
  }
}

# RDS Cluster with unencrypted storage
resource "aws_rds_cluster" "test-cluster-unencrypted" {
  cluster_identifier = local.cluster_name_unencrypted
  
  engine         = var.cluster_engine
  engine_version = var.cluster_engine_version
  
  database_name   = var.db_name
  master_username = var.db_username
  master_password = var.db_password
  
  storage_encrypted = false
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    Name = local.cluster_name_unencrypted
    Type = "unencrypted-cluster"
  }
}

# =============================================================================
# RDS CLUSTER INSTANCES (Aurora cluster members)
# =============================================================================

# RDS Cluster Instance for encrypted cluster
resource "aws_rds_cluster_instance" "test-cluster-instance-encrypted" {
  identifier         = "${local.cluster_name_encrypted}-instance-1"
  cluster_identifier = aws_rds_cluster.test-cluster-encrypted.cluster_identifier
  
  instance_class = var.cluster_instance_class
  engine         = aws_rds_cluster.test-cluster-encrypted.engine
  engine_version = aws_rds_cluster.test-cluster-encrypted.engine_version
  
  tags = {
    Name = "${local.cluster_name_encrypted}-instance-1"
    Type = "encrypted-cluster-instance"
  }
}

# RDS Cluster Instance for unencrypted cluster
resource "aws_rds_cluster_instance" "test-cluster-instance-unencrypted" {
  identifier         = "${local.cluster_name_unencrypted}-instance-1"
  cluster_identifier = aws_rds_cluster.test-cluster-unencrypted.cluster_identifier

  instance_class = var.cluster_instance_class
  engine         = aws_rds_cluster.test-cluster-unencrypted.engine
  engine_version = aws_rds_cluster.test-cluster-unencrypted.engine_version
  
  tags = {
    Name = "${local.cluster_name_unencrypted}-instance-1"
    Type = "unencrypted-cluster-instance"
  }
}

# =============================================================================
# RDS GLOBAL CLUSTERS (Multi-region Aurora)
# =============================================================================

# RDS Global Cluster with encrypted storage
resource "aws_rds_global_cluster" "test-global-cluster-encrypted" {
  global_cluster_identifier = local.global_cluster_name_encrypted
  
  engine         = var.cluster_engine
  engine_version = var.cluster_engine_version
  
  storage_encrypted = true
  
  tags = {
    Name = local.global_cluster_name_encrypted
    Type = "encrypted-global-cluster"
  }
}

# RDS Global Cluster with unencrypted storage
resource "aws_rds_global_cluster" "test-global-cluster-unencrypted" {
  global_cluster_identifier = local.global_cluster_name_unencrypted
  
  engine         = var.cluster_engine
  engine_version = var.cluster_engine_version
  
  storage_encrypted = false
  
  tags = {
    Name = local.global_cluster_name_unencrypted
    Type = "unencrypted-global-cluster"
  }
}

# ElastiCache Redis replication group with encryption at rest enabled
resource "aws_elasticache_replication_group" "redis_rep_encrypted" {
  replication_group_id       = local.redis_replication_group_encrypted
  description                = "Redis replication group with encryption at rest enabled"
  engine                     = "redis"
  engine_version             = "6.2"
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 2
  parameter_group_name       = "default.redis6.x"
  port                       = 6379
  automatic_failover_enabled = true

  # Enable encryption at rest
  at_rest_encryption_enabled = true
  # Optionally specify a KMS key: kms_key_id = var.redis_kms_key_id

  tags = {
    Name = local.redis_replication_group_encrypted
    Type = "encrypted-redis-replication-group"
  }
}

# ElastiCache Redis replication group with encryption at rest disabled
resource "aws_elasticache_replication_group" "redis_rep_unencrypted" {
  replication_group_id       = local.redis_replication_group_unencrypted
  description                = "Redis replication group with encryption at rest disabled"
  engine                     = "redis"
  engine_version             = "6.2"
  node_type                  = "cache.t3.micro"
  num_cache_clusters         = 2
  parameter_group_name       = "default.redis6.x"
  port                       = 6379
  automatic_failover_enabled = true

  # Disable encryption at rest (explicit)
  at_rest_encryption_enabled = false

  tags = {
    Name = local.redis_replication_group_unencrypted
    Type = "unencrypted-redis-replication-group"
  }
}

# Encrypted bucket - bucket only (encryption managed via dedicated resource)
resource "aws_s3_bucket" "test_bucket_encrypted" {
  bucket = local.s3_bucket_encrypted

  tags = {
    Name = local.s3_bucket_encrypted
    Type = "encrypted-s3"
  }
}

# Server-side encryption configuration as a separate resource (preferred)
resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket_encrypted" {
  bucket = local.s3_bucket_encrypted

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Unencrypted bucket - intentionally missing server_side_encryption_configuration
resource "aws_s3_bucket" "test_bucket_unencrypted" {
  bucket = local.s3_bucket_unencrypted

  tags = {
    Name = local.s3_bucket_unencrypted
    Type = "unencrypted-s3"
  }
}
*/
# End of commented resource blocks

# =============================================================================
# NEW DUMMY RESOURCES FOR TAG TESTING
# =============================================================================

# 1. Bucket with NO tags (should fail Sentinel policy)
# resource "aws_s3_bucket" "no_tags" {
#   bucket = local.bucket_no_tags
# }

# resource "aws_s3_bucket" "wrong_tags" {
#   bucket = local.bucket_wrong_tags

#   tags = {
#     Name       = "test-bucket"
#     Owner      = "platform-team"
#     Project    = "testing"
#     Department = "engineering"
#   }
# }

# resource "aws_s3_bucket" "only_env" {
#   bucket = local.bucket_only_one_tag

#   tags = {
#     env = "dev"
#   }
# }

# resource "aws_s3_bucket" "env_cost_center" {
#   bucket = local.bucket_only_two_tags

#   tags = {
#     env         = "staging"
#     cost-center = "operations"
#   }
# }

# resource "aws_s3_bucket" "partial_wrong" {
#   bucket = local.bucket_partial_wrong

#   tags = {
#     env         = "dev"
#     Owner       = "platform-team"
#     Project     = "testing"
#     Description = "test bucket"
#   }
# }


# 2. Bucket with all lowercase tags: env, cost-center, hcp_product
# resource "aws_instance" "test_pass_all_valid" {
#   ami           = var.ami
#   instance_type = var.instance_type

#   tags = {
#     env          = "dev"
#     cost_center  = "engineering_cogs"
#     hcp_product  = "sentinel"
#     github_repo  = "hashicorp/cloud-infra-sentinel-policy"
#     owner        = "team@hashicorp.com"
#   }
# }

# resource "aws_sqs_queue" "test_pass_one_missing" {
#   name = "test-queue"

#   tags = {
#     cost_center  = "data_opex"
#     hcp_product  = "vault-radar"
#     github_repo  = "hashicorp/vault"
#     owner        = "user.name@example.com"
#   }
# }

# # 3. Bucket with all UPPERCASE tags: ENV, COST-CENTER, HCP_PRODUCT
# resource "aws_s3_bucket" "uppercase_tags" {
#   bucket = local.bucket_uppercase

#   tags = {
#     ENV         = "prod"
#     COST-CENTER = "operations"
#     HCP_PRODUCT = "terraform"
#   }
# }

# # 4. Bucket with mixed case tags: Env, Cost-Center, Hcp_Product
# resource "aws_s3_bucket" "mixed_case_tags" {
#   bucket = local.bucket_mixed_case

#   tags = {
#     Env         = "staging"
#     Cost-Center = "finance"
#     Hcp_Product = "vault"
#   }
# }

# # 5. Bucket with PascalCase tags: Env, CostCenter, HcpProduct
# resource "aws_s3_bucket" "pascal_case_tags" {
#   bucket = local.bucket_pascal_case

#   tags = {
#     Environment = "test"
#     CostCenter  = "marketing"
#     HcpProduct  = "consul"
#   }
# }

# # 6. Bucket with SNAKE_UPPER tags: ENV, COST_CENTER, HCP_PRODUCT
# resource "aws_s3_bucket" "snake_upper_tags" {
#   bucket = local.bucket_snake_upper

#   tags = {
#     ENV         = "uat"
#     COST_CENTER = "sales"
#     HCP_PRODUCT = "boundary"
#   }
# }

# # 7. Bucket with kebab-case tags: env, cost-center, hcp-product
# resource "aws_s3_bucket" "kebab_case_tags" {
#   bucket = local.bucket_kebab_case

#   tags = {
#     env         = "qa"
#     cost-center = "support"
#     hcp-product = "waypoint"
#   }
# }
resource "aws_instance" "test_fail_invalid_env" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    env          = "invalid-env"
    cost_center  = "engineering_opex"
    hcp_product  = "vault-radar"
    github_repo  = "hashicorp/cloud-vault-scanning-infra"
    owner        = "team@hashicorp.com"
  }
}

resource "aws_db_instance" "test_fail_invalid_email" {
  allocated_storage = 20
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  username          = "admin"
  password          = "password123"

  tags = {
    env          = "dev"
    cost_center  = "platform_opex"
    hcp_product  = "hcp-vault"
    github_repo  = "hashicorp/vault"
    owner        = "not-an-email"
  }
}

resource "aws_sqs_queue" "test_fail_invalid_github_repo" {
  name = "test-queue"

  tags = {
    env          = "int"
    cost_center  = "data_opex"
    hcp_product  = "boundary"
    github_repo  = "invalid-repo-format"
    owner        = "user@example.com"
  }
}

resource "aws_sns_topic" "test_fail_invalid_cost_center" {
  name = "test-topic"

  tags = {
    env          = "prod"
    cost_center  = "engineering"
    hcp_product  = "consul"
    github_repo  = "hashicorp/consul"
    owner        = "team@hashicorp.com"
  }
}

resource "aws_rds_cluster" "test_fail_multiple_invalid" {
  cluster_identifier = "test-cluster"
  engine             = "aurora-postgresql"
  master_username    = "admin"
  master_password    = "password123"

  tags = {
    env          = "live"
    cost_center  = "platform"
    hcp_product  = "waypoint"
    github_repo  = "waypoint"
    owner        = "invalid-email"
  }
}
