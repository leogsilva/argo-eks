
provider "aws" {
  version = ">= 2.28.1"
  region  = "us-east-1"
}

locals {
  oidc_id = split("/", "${var.oidc_arn}")[3]
}

resource "aws_iam_role" "serviceaccount_role" {
  name = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.oidc_arn}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "oidc.eks.${var.region}.amazonaws.com/id/${local.oidc_id}:sub": "system:serviceaccount:${var.serviceaccount_name}"
        }
      }
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"

  policy = var.policy
}

resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "policy-attachment"
  roles      = [aws_iam_role.serviceaccount_role.name]
  policy_arn = aws_iam_policy.policy.arn
}