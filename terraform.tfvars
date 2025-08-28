region = "us-east-1"

# EC2 variables
ami = "ami-020cba7c55df1f615"
instance_type = "t2.micro"

# RDS Instance variables
db_engine = "mysql"
db_engine_version = "8.0"
db_instance_class = "db.t3.micro"
db_allocated_storage = 20
db_name = "testdb"
db_username = "admin"
db_password = "TestPassword123!"

# RDS Cluster variables
cluster_engine = "aurora-mysql"
cluster_engine_version = "8.0.mysql_aurora.3.02.0"
cluster_instance_class = "db.r5.large"
