module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = local.cluster_name
  subnets      = module.vpc.private_subnets

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id
  enable_irsa = true

  worker_groups_launch_template = [
    {
      name                    = "spot-${var.cluster_name}"
      override_instance_types = var.instance_types
      spot_instance_pools     = 4
      asg_max_size            = 5
      asg_desired_capacity    = var.capacity
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      public_ip               = false 
    },
  ]

}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
