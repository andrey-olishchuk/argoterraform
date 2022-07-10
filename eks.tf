module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  worker_ami_name_filter_windows = "*"
  version                        = "17.1.0"
  tags = {
    Name = "terraform"
  }

  cluster_name    = "terraform"
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    nodegroup = {
      node_group_name  = "terraform"
      disk_size        = var.disk_size
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity

      instance_types = var.instance_types
      public_ip      = var.public_ip 
      tags = {
        Environment = "terraform"
        Name = "terraform"
      }
      labels = {
        Environment = "terraform"
        Name = "terraform"
      }
      k8s_labels = {
        Environment = "terraform"
        Name = "terraform"
      }
    }
  }
}

resource "aws_iam_policy" "ekspolicy" {
  name        = "terraform"
  description = "Policy for k8s"

  policy = jsonencode(
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:*",
          "s3:*",
          "sts:AssumeRole",
          "*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  })
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}