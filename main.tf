terraform { 
  cloud { 
    
    organization = "greed-island" 

    workspaces { 
      name = "sentinel-x-sentinel" 
    } 
  } 
}

locals {
  workspace_prefix = terraform.workspace
}

provider "aws" {
  region = var.region
}

# =============================================================================
# TEST CASE 1: EC2 with encrypted root block device
# =============================================================================
resource "aws_instance" "ec2-encrypted-root" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
    delete_on_termination = true
  }

  tags = {
    Name = "${local.workspace_prefix}-ec2-encrypted-root"
    TestCase = "encrypted-root-block-device"
  }
}

# =============================================================================
# TEST CASE 2: EC2 with unencrypted root block device
# =============================================================================
resource "aws_instance" "ec2-unencrypted-root" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = false
    delete_on_termination = true
  }

  tags = {
    Name = "${local.workspace_prefix}-ec2-unencrypted-root"
    TestCase = "unencrypted-root-block-device"
  }
}

# =============================================================================
# TEST CASE 3: EC2 with no root block device specified (uses AMI defaults)
# =============================================================================
resource "aws_instance" "ec2-no-root-specified" {
  ami           = var.ami
  instance_type = var.instance_type

  # No root_block_device specified - inherits from AMI
  
  tags = {
    Name = "${local.workspace_prefix}-ec2-no-root-specified"
    TestCase = "no-root-block-device-specified"
  }
}

# =============================================================================
# TEST CASE 4: EC2 with additional encrypted EBS volumes
# =============================================================================
resource "aws_instance" "ec2-encrypted-additional-volumes" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp3"
    volume_size = 10
    encrypted   = true
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_type = "gp3"
    volume_size = 15
    encrypted   = true
    delete_on_termination = true
  }

  tags = {
    Name = "${local.workspace_prefix}-ec2-encrypted-additional-volumes"
    TestCase = "encrypted-additional-ebs-volumes"
  }
}

# =============================================================================
# TEST CASE 5: EC2 with mixed encryption (encrypted root, unencrypted additional)
# =============================================================================
resource "aws_instance" "ec2-mixed-encryption" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp3"
    volume_size = 10
    encrypted   = false  # Unencrypted additional volume
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_type = "gp3"
    volume_size = 15
    encrypted   = true   # Encrypted additional volume
    delete_on_termination = true
  }

  tags = {
    Name = "${local.workspace_prefix}-ec2-mixed-encryption"
    TestCase = "mixed-encryption-volumes"
  }
}

# =============================================================================
# TEST CASE 6: EC2 with all unencrypted volumes
# =============================================================================
resource "aws_instance" "ec2-all-unencrypted" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = false
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp3"
    volume_size = 10
    encrypted   = false
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdg"
    volume_type = "gp3"
    volume_size = 15
    encrypted   = false
    delete_on_termination = true
  }

  tags = {
    Name = "${local.workspace_prefix}-ec2-all-unencrypted"
    TestCase = "all-unencrypted-volumes"
  }
}

# =============================================================================
# TEST CASE 7: EC2 with encrypted volumes using KMS key
# =============================================================================
resource "aws_instance" "ec2-kms-encrypted" {
  ami           = var.ami
  instance_type = var.instance_type

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
    kms_key_id  = var.kms_key_id
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/sdf"
    volume_type = "gp3"
    volume_size = 10
    encrypted   = true
    kms_key_id  = var.kms_key_id
    delete_on_termination = true
  }

  tags = {
    Name = "${local.workspace_prefix}-ec2-kms-encrypted"
    TestCase = "kms-encrypted-volumes"
  }
}

# =============================================================================
# STANDALONE EBS VOLUMES for additional testing
# =============================================================================

# Encrypted standalone EBS volume
resource "aws_ebs_volume" "encrypted-standalone" {
  availability_zone = "${var.region}a"
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "${local.workspace_prefix}-encrypted-standalone-volume"
    TestCase = "encrypted-standalone-ebs"
  }
}

# Unencrypted standalone EBS volume
resource "aws_ebs_volume" "unencrypted-standalone" {
  availability_zone = "${var.region}a"
  size              = 10
  type              = "gp3"
  encrypted         = false

  tags = {
    Name = "${local.workspace_prefix}-unencrypted-standalone-volume"
    TestCase = "unencrypted-standalone-ebs"
  }
}

# Encrypted standalone EBS volume with KMS key
resource "aws_ebs_volume" "kms-encrypted-standalone" {
  availability_zone = "${var.region}a"
  size              = 10
  type              = "gp3"
  encrypted         = true
  kms_key_id        = var.kms_key_id

  tags = {
    Name = "${local.workspace_prefix}-kms-encrypted-standalone-volume"
    TestCase = "kms-encrypted-standalone-ebs"
  }
}
