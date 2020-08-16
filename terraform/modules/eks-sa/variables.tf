
variable "role_name" {
    type = string
    description = "Name for serviceaccount role"
}

variable "serviceaccount_name" {
    type = string
    description = "Kubernetes service account name in format namespace:saname"
}

variable "oidc_arn" {
    type = string
    description = "openid connect provider arn"
}

variable "region" {
    type = string
    description = "aws region"
    default = "us-east-1"
}

variable "policy" {
    type = string
    description = "Json for policy"
}