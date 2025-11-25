terraform { 
  cloud { 
    organization = "greed-island" 

    workspaces { 
      name = "sentinel-x-sentinel" 
    } 
  } 
}
provider "aws" {
  region = var.region
}

resource "aws_instance" "imdsv2_required" {
  ami           = var.ami
  instance_type = var.instance_type

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"  # This enforces IMDSv2
    http_put_response_hop_limit = 1
  }

  tags = {
    Name        = "test-instance"
    Environment = "test"
    Purpose     = "sentinel-policy-testing"
  }
}
