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
