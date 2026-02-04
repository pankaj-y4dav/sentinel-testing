terraform { 
  cloud { 
    organization = "greed-island" 

    workspaces { 
      name = "sentinel-x-sentinel" 
    } 
  } 
}

locals {
  # WAF tag test resources
  alb_external_no_waf = "test-alb-external-no-waf"
  alb_external_with_waf = "test-alb-external-with-waf"
  alb_internal = "test-alb-internal"
  cf_enabled_no_waf = "test-cf-enabled-no-waf"
  cf_enabled_with_waf = "test-cf-enabled-with-waf"
  cf_disabled = "test-cf-disabled"

  # Commented out encryption test resources
  # instance_name_encrypted = "test-instance-encrypted"
  # instance_name_unencrypted = "test-instance-unencrypted"
  # db_name_encrypted = "test-db-encrypted"
  # db_name_unencrypted = "test-db-unencrypted"
  # cluster_name_encrypted = "test-cluster-encrypted"
  # cluster_name_unencrypted = "test-cluster-unencrypted"
  # global_cluster_name_encrypted = "test-global-encrypted"
  # global_cluster_name_unencrypted = "test-global-unencrypted"
  # elasticsearch_domain_encrypted = "test-es-encrypted"
  # elasticsearch_domain_unencrypted = "test-es-unencrypted"
  # redis_replication_group_encrypted = "test-redis-replication-encrypted"
  # redis_replication_group_unencrypted = "test-redis-replication-unencrypted"
  # s3_bucket_encrypted   = "test-s3-encrypted"
  # s3_bucket_unencrypted = "test-s3-unencrypted"
}

provider "aws" {
  region = var.region
}

# =============================================================================
# WAF TAG TEST RESOURCES - ALB & CloudFront
# =============================================================================

# VPC for ALB resources
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "test-vpc-waf"
  }
}

# Subnets for ALB
resource "aws_subnet" "test_subnet_1" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  
  tags = {
    Name = "test-subnet-1"
  }
}

resource "aws_subnet" "test_subnet_2" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  
  tags = {
    Name = "test-subnet-2"
  }
}

# FAIL: External ALB without security_waf_acl tag
resource "aws_lb" "external_alb_no_waf" {
  name               = local.alb_external_no_waf
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.test_subnet_1.id, aws_subnet.test_subnet_2.id]

  tags = {
    Name        = local.alb_external_no_waf
    Environment = "test"
    # Missing security_waf_acl tag - SHOULD FAIL
  }
}

# PASS: External ALB with security_waf_acl tag
# resource "aws_lb" "external_alb_with_waf" {
#   name               = local.alb_external_with_waf
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = [aws_subnet.test_subnet_1.id, aws_subnet.test_subnet_2.id]

#   tags = {
#     Name             = local.alb_external_with_waf
#     Environment      = "test"
#     security_waf_acl = "test-waf-acl-arn"
#   }
# }

# PASS: Internal ALB without security_waf_acl tag (internal ALBs don't require WAF)
# resource "aws_lb" "internal_alb" {
#   name               = local.alb_internal
#   internal           = true
#   load_balancer_type = "application"
#   subnets            = [aws_subnet.test_subnet_1.id, aws_subnet.test_subnet_2.id]

#   tags = {
#     Name        = local.alb_internal
#     Environment = "test"
#     # No security_waf_acl tag but internal - SHOULD PASS
#   }
# }

# S3 bucket for CloudFront origin
resource "aws_s3_bucket" "cf_origin" {
  bucket = "test-cf-origin-bucket-waf"

  tags = {
    Name = "cf-origin-bucket"
  }
}

# FAIL: Enabled CloudFront distribution without security_waf_acl tag
resource "aws_cloudfront_distribution" "enabled_cf_no_waf" {
  enabled = true
  comment = "CloudFront distribution enabled without WAF tag"

  origin {
    domain_name = aws_s3_bucket.cf_origin.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.cf_origin.id}"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${aws_s3_bucket.cf_origin.id}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name        = local.cf_enabled_no_waf
    Environment = "test"
    # Missing security_waf_acl tag and enabled - SHOULD FAIL
  }
}

# PASS: Enabled CloudFront distribution with security_waf_acl tag
# resource "aws_cloudfront_distribution" "enabled_cf_with_waf" {
#   enabled = true
#   comment = "CloudFront distribution enabled with WAF tag"

#   origin {
#     domain_name = aws_s3_bucket.cf_origin.bucket_regional_domain_name
#     origin_id   = "S3-${aws_s3_bucket.cf_origin.id}"
#   }

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD"]
#     cached_methods         = ["GET", "HEAD"]
#     target_origin_id       = "S3-${aws_s3_bucket.cf_origin.id}"
#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags = {
#     Name             = local.cf_enabled_with_waf
#     Environment      = "test"
#     security_waf_acl = "test-waf-acl-arn"
#   }
# }

# PASS: Disabled CloudFront distribution without security_waf_acl tag (disabled distributions don't require WAF)
# resource "aws_cloudfront_distribution" "disabled_cf" {
#   enabled = false
#   comment = "CloudFront distribution disabled without WAF tag"

#   origin {
#     domain_name = aws_s3_bucket.cf_origin.bucket_regional_domain_name
#     origin_id   = "S3-${aws_s3_bucket.cf_origin.id}"
#   }

#   default_cache_behavior {
#     allowed_methods        = ["GET", "HEAD"]
#     cached_methods         = ["GET", "HEAD"]
#     target_origin_id       = "S3-${aws_s3_bucket.cf_origin.id}"
#     viewer_protocol_policy = "redirect-to-https"

#     forwarded_values {
#       query_string = false
#       cookies {
#         forward = "none"
#       }
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   tags = {
#     Name        = local.cf_disabled
#     Environment = "test"
#     # No security_waf_acl tag but disabled - SHOULD PASS
#   }
# }

# =============================================================================
# COMMENTED OUT - Previous encryption test resources
# =============================================================================

# # Elasticsearch domain with encryption at rest enabled
# resource "aws_elasticsearch_domain" "test-es-encrypted" {
#   domain_name           = local.elasticsearch_domain_encrypted
#   elasticsearch_version = "7.10"
# 
#   cluster_config {
#     instance_type = "t3.small.elasticsearch"
#     instance_count = 1
#   }
# 
#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }
# 
#   encrypt_at_rest {
#     enabled = true
#   }
# 
#   tags = {
#     Name = local.elasticsearch_domain_encrypted
#     Type = "encrypted-elasticsearch"
#   }
# }
# 
# # Elasticsearch domain with encryption at rest disabled
# resource "aws_elasticsearch_domain" "test-es-unencrypted" {
#   domain_name           = local.elasticsearch_domain_unencrypted
#   elasticsearch_version = "7.10"
# 
#   cluster_config {
#     instance_type = "t3.small.elasticsearch"
#     instance_count = 1
#   }
# 
#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10
#   }
# 
#   encrypt_at_rest {
#     enabled = false
#   }
# 
#   tags = {
#     Name = local.elasticsearch_domain_unencrypted
#     Type = "unencrypted-elasticsearch"
#   }
# }
# 
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
# # EC2 Instance with unencrypted root EBS volume
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
# 
# # ElastiCache Redis replication group with encryption at rest enabled
# resource "aws_elasticache_replication_group" "redis_rep_encrypted" {
#   replication_group_id       = local.redis_replication_group_encrypted
#   description                = "Redis replication group with encryption at rest enabled"
#   engine                     = "redis"
#   engine_version             = "6.2"
#   node_type                  = "cache.t3.micro"
#   num_cache_clusters         = 2
#   parameter_group_name       = "default.redis6.x"
#   port                       = 6379
#   automatic_failover_enabled = true
# 
#   # Enable encryption at rest
#   at_rest_encryption_enabled = true
#   # Optionally specify a KMS key: kms_key_id = var.redis_kms_key_id
# 
#   tags = {
#     Name = local.redis_replication_group_encrypted
#     Type = "encrypted-redis-replication-group"
#   }
# }
# 
# # ElastiCache Redis replication group with encryption at rest disabled
# resource "aws_elasticache_replication_group" "redis_rep_unencrypted" {
#   replication_group_id       = local.redis_replication_group_unencrypted
#   description                = "Redis replication group with encryption at rest disabled"
#   engine                     = "redis"
#   engine_version             = "6.2"
#   node_type                  = "cache.t3.micro"
#   num_cache_clusters         = 2
#   parameter_group_name       = "default.redis6.x"
#   port                       = 6379
#   automatic_failover_enabled = true
# 
#   # Disable encryption at rest (explicit)
#   at_rest_encryption_enabled = false
# 
#   tags = {
#     Name = local.redis_replication_group_unencrypted
#     Type = "unencrypted-redis-replication-group"
#   }
# }
# 
# # Encrypted bucket - bucket only (encryption managed via dedicated resource)
# resource "aws_s3_bucket" "test_bucket_encrypted" {
#   bucket = local.s3_bucket_encrypted
# 
#   tags = {
#     Name = local.s3_bucket_encrypted
#     Type = "encrypted-s3"
#   }
# }
# 
# # Server-side encryption configuration as a separate resource (preferred)
# resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket_encrypted" {
#   bucket = local.s3_bucket_encrypted
# 
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }
# 
# # Unencrypted bucket - intentionally missing server_side_encryption_configuration
# resource "aws_s3_bucket" "test_bucket_unencrypted" {
#   bucket = local.s3_bucket_unencrypted
# 
#   tags = {
#     Name = local.s3_bucket_unencrypted
#     Type = "unencrypted-s3"
#   }
# }
