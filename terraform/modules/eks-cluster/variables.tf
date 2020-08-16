
variable "cluster_name" {
    type = string
    description = "Cluster name"
}

variable "region" {
  default     = "us-east-2"
  description = "AWS region"
}

variable "capacity" {
  default = 2
  description = "Desired capacity for nodes"
}

variable "instance_types" {
  type = list(string)
  description = "(optional) describe your variable"
  default = [
    "m5.large", "m5a.large", "m5d.large", "m5ad.large"
  ]
}