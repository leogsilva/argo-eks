
data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

module "edge_cluster" {
  source = "../modules/eks-cluster"
  region = "us-east-1"
  cluster_name = "edge"
  instance_types = ["t3.medium"]
}

resource "aws_s3_bucket" "argo_bucket" {
  bucket = "br-com-eks-argo-install-${local.account_id}"
  acl    = "private"

  tags = {
    Name        = "Argo bucket"
    Environment = "Dev"
  }
}

module "edge_argo_serviceaccount" {
  source = "../modules/eks-sa"
  role_name = "argo"
  serviceaccount_name = "argo:argo"
  region = "us-east-1"
  oidc_arn = module.edge_cluster.oidc_arn
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.argo_bucket.arn}",
        "${aws_s3_bucket.argo_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_user" "argo" {
  name = "argo"
  path = "/kubernetes/"

  tags = {
    solution = "argo"
  }
}

resource "aws_iam_access_key" "argo_access_key" {
  user = aws_iam_user.argo.name
}

resource "aws_iam_user_policy" "s3_policy" {
  name = "s3-policy"
  user = aws_iam_user.argo.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.argo_bucket.arn}",
        "${aws_s3_bucket.argo_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

output "cluster_name" {
    value = module.edge_cluster.cluster_name
}

output "bucket_name" {
    value = aws_s3_bucket.argo_bucket.id
}

output "secret_id" {
    value = aws_iam_access_key.argo_access_key.secret
}

output "access_key" {
    value = aws_iam_access_key.argo_access_key.id
}