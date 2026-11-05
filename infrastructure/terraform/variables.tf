variable "aws_region" {
  description = "AWS region for this lab"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  type    = string
  default = "product-catalog-eks"
}

variable "kubernetes_version" {
  description = "Choose an EKS Kubernetes version currently supported in your region"
  type        = string
  default     = "1.33"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}

variable "desired_nodes" {
  type    = number
  default = 2
}

variable "min_nodes" {
  type    = number
  default = 2
}

variable "max_nodes" {
  type    = number
  default = 4
}
