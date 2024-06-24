terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  shared_config_files      = ["/Users/317447/.aws/config"]
  shared_credentials_files = ["/Users/317447/.aws/credentials"]
  profile                  = "cp-sec"
}

resource "aws_s3_bucket" "cp-sec-tf1" {
  bucket = "cp-sec-tf1"

  tags = {
    Name        = "cp-sec-tf1"
    cost        = "123"
  }
}

resource "aws_s3_bucket_versioning" "cp-sec-tf1" {
  bucket = aws_s3_bucket.cp-sec-tf1.id
  versioning_configuration {
    status = "${var.s3_versioninfg}"
  }
}

resource "aws_s3_bucket_policy" "cp-sec-tf1" {
  bucket = aws_s3_bucket.cp-sec-tf1.id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPublicReadCannedAcl",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::024960558254:root"
            },
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::cp-sec-tf1/*"
        }
    ]
}
EOF
}