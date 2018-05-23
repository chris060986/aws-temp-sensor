provider "aws" {
  # aws api key added as environment variables
  region = "eu-central-1"
}

resource "aws_iot_thing" "example" {
  name = "first_test"

  attributes {
    First = "temp"
  }
}

# create an elasticservice domain
# Cognito User Pool, Cognito Identity Pool, IAM Role and users are created manually at the moment.
resource "aws_elasticsearch_domain" "es" {
  domain_name           = "mirj"
  elasticsearch_version = "6.2"
  cluster_config {
    instance_type = "t2.small.elasticsearch"
    instance_count = 1
  }

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  ebs_options {
    ebs_enabled = "true"
    volume_type = "General Purpose (SSD)"
    volume_size = "10"
  }

  access_policies = <<CONFIG
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::671323360782:role/Cognito_elasticAuth_Role"
          },
          "Action": "es:*",
          "Resource": "arn:aws:es:eu-central-1:671323360782:domain/mirj/*"
        }
      ]
    }
    CONFIG

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

 }