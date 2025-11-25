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

resource "aws_instance" "imdsv2_optional" {
  ami           = var.ami
  instance_type = var.instance_type

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"  # This allows IMDSv1 - FAILS policy
  }

  tags = {
    Name        = "imdsv2-optional-instance"
    Environment = "test"
    Purpose     = "sentinel-policy-testing"
  }
}

# FAIL: EC2 instance without metadata_options block (defaults to optional)
resource "aws_instance" "no_metadata_options" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name        = "no-metadata-options-instance"
    Environment = "test"
    Purpose     = "sentinel-policy-testing"
  }
}

# FAIL: EC2 instance with metadata disabled
resource "aws_instance" "metadata_disabled" {
  ami           = var.ami
  instance_type = var.instance_type

  metadata_options {
    http_endpoint = "disabled"
  }

  tags = {
    Name        = "metadata-disabled-instance"
    Environment = "test"
    Purpose     = "sentinel-policy-testing"
  }
}
