variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "The type of instance to create"
  type        = string
  default     = "t2.micro"
}

# RDS Instance variables
variable "db_engine" {
  description = "The database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "The RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "The allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "testdb"
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true
}

# RDS Cluster variables
variable "cluster_engine" {
  description = "The Aurora cluster engine"
  type        = string
  default     = "aurora-mysql"
}

variable "cluster_engine_version" {
  description = "The Aurora cluster engine version"
  type        = string
  default     = "8.0.mysql_aurora.3.02.0"
}

variable "cluster_instance_class" {
  description = "The Aurora cluster instance class"
  type        = string
  default     = "db.r5.large"
}

variable "kms_key_id" {
  description = "The KMS key ID for encryption (optional)"
  type        = string
  default     = null
}
