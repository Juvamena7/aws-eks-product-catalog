# End-to-end deployment steps

## 1. Local prerequisites
Install/configure AWS CLI v2, Terraform, kubectl, Docker, and Git. Confirm `aws sts get-caller-identity` shows the intended account. Never paste credentials into source files.

## 2. Create infrastructure
```bash
cd infrastructure/terraform
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```
Review the plan and cost implications before approving. Confirm the EKS Kubernetes version is supported in your region.

## 3. Connect kubectl
```bash
aws eks update-kubeconfig --region ap-south-1 --name product-catalog-eks
kubectl get nodes
```
Worker nodes should be in private subnets. Their outbound access to AWS services and image registries must be available through NAT or the appropriate VPC endpoints.

## 4. Configure CI/CD
- Create GitHub OIDC federation and a least-privilege IAM role.
- Add the role ARN as repository secret `AWS_GITHUB_ACTIONS_ROLE_ARN`.
- Verify the workflow region, cluster name, repository name, and namespace match Terraform.
- Grant the deployment role appropriate EKS access and namespace-scoped Kubernetes permissions.
- Push to `main`; inspect the Actions run and wait for rollout status.

## 5. Install ALB controller
Follow the official AWS Load Balancer Controller installation guide for your EKS version. Configure its IAM role/service account, then apply:
```bash
kubectl apply -f kubernetes/ingress.yaml
kubectl get ingress -n product-catalog
```
The controller creates an ALB in tagged public subnets for internet-facing ingress. For HTTPS, request/validate an ACM certificate and add its ARN and listener annotations.

## 6. Verify application
```bash
kubectl get all -n product-catalog
kubectl get hpa -n product-catalog
kubectl rollout status deployment/product-catalog -n product-catalog
kubectl logs deployment/product-catalog -n product-catalog
```
Open the ALB hostname from `kubectl get ingress -n product-catalog`, then test `/` and `/api/products`.

## 7. Important image-manifest note
The initial `deployment.yaml` uses a public Node image as a safe placeholder. The GitHub Actions workflow replaces it with the exact ECR image built for the commit. If deploying manually, set the deployment image to the ECR URI:
```bash
kubectl set image deployment/product-catalog product-catalog=ACCOUNT_ID.dkr.ecr.ap-south-1.amazonaws.com/product-catalog:IMAGE_TAG -n product-catalog
```

## 8. Cost cleanup
Delete the Ingress first and wait for the ALB to be removed:
```bash
kubectl delete -f kubernetes/ingress.yaml
```
Then destroy Terraform resources:
```bash
cd infrastructure/terraform
terraform destroy
```
Confirm no EKS clusters, NAT Gateways, load balancers, or unattached EBS volumes remain. ECR images may remain and incur storage charges.
