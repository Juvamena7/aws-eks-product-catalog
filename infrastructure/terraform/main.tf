data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.20.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24", "10.20.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    general = {
      name           = "product_catalog_workers"
      instance_types = var.node_instance_types
      min_size       = var.min_nodes
      max_size       = var.max_nodes
      desired_size   = var.desired_nodes

      capacity_type = "ON_DEMAND"

      iam_role_name            = "pc-workers-role"
      iam_role_use_name_prefix = false
    }
  }

  tags = {
    Project = "ProductCatalog"
    Owner   = "PathnexStudent"
  }
}

resource "aws_ecr_repository" "product_catalog" {
  name                 = "product-catalog"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Project = "ProductCatalog"
    Owner   = "PathnexStudent"
  }
}

resource "aws_ecr_lifecycle_policy" "product_catalog" {
  repository = aws_ecr_repository.product_catalog.name
  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep latest 20 tagged images"
      selection = {
        tagStatus     = "tagged"
        tagPrefixList = ["v", "sha-"]
        countType     = "imageCountMoreThan"
        countNumber   = 20
      }
      action = { type = "expire" }
    }]
  })
}
