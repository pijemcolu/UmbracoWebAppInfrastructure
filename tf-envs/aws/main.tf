resource "aws_elastic_beanstalk_application" "app" {
  name        = "app-1654616"
  description = "Random terraform test resource"

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk.arn
    max_count             = 128
    delete_source_from_s3 = true
  }
  tags = {
    user = "mto"
  }
}

resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tf-test-name"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Windows Server 2019 v2.5.11 running IIS 10.0"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.subject_profile.name
  }
  tags = {
    user = "mto"
  }
}

resource "aws_iam_instance_profile" "subject_profile" {
  name  = "instanceprofile"
  role = aws_iam_role.beanstalk.id
}

resource "aws_iam_role" "beanstalk" {
  name = "testrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    user = "mto"
  }
}

resource "aws_resourcegroups_group" "test" {
  name = "test-group"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "user",
      "Values": ["mto"]
    }
  ]
}
JSON
  }
}
