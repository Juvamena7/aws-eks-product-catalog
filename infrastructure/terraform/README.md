# Terraform infrastructure

This Terraform starter creates a VPC with public/private subnets, a private EKS managed node group, and an immutable ECR repository with image scanning.

## Before applying
- Check the EKS Kubernetes versions supported in your selected region. Change `kubernetes_version` in `variables.tf` if needed.
- This lab uses a single NAT Gateway to reduce cost versus one NAT Gateway per AZ, but it is not a highly available production design.
- EKS, EC2 worker nodes, NAT Gateway, load balancers, and data transfer can incur charges.
- Terraform state is local by default. For team use, configure a secured remote backend with encryption, versioning, and locking before applying.
- Do not commit `terraform.tfvars`, state files, credentials, or kubeconfig.

## Commands
```bash
cd infrastructure/terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
aws eks update-kubeconfig --region ap-south-1 --name product-catalog-eks
kubectl get nodes
```

Destroy lab resources when finished:
```bash
terraform destroy
```

The AWS Load Balancer Controller is not installed by this Terraform starter. Install it with the official AWS documentation and its recommended IAM permissions before applying `kubernetes/ingress.yaml`.
