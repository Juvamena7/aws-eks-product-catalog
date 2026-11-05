# End-to-End AWS DevOps: Product Catalog on EKS

A learning project demonstrating GitHub Actions CI/CD, Docker, Amazon ECR, private Amazon EKS worker nodes, AWS Load Balancer Controller/ALB, Kubernetes health checks and autoscaling, CloudWatch monitoring, and rollback.

## Architecture
Developer → GitHub → GitHub Actions → Docker build/smoke test → Amazon ECR → Amazon EKS private worker nodes → Kubernetes Service → AWS ALB → users. Logs and metrics flow to CloudWatch.

## Repository contents
- `app/`: simple Node.js Product Catalog demo.
- `Dockerfile`: non-root container image.
- `.github/workflows/deploy.yml`: build, smoke test, ECR push, and EKS deployment.
- `infrastructure/terraform/`: VPC, private EKS managed nodes, and ECR.
- `kubernetes/`: namespace, service account, Deployment, Service, HPA, and ALB Ingress.
- `security/`, `monitoring/`, `docs/`: security checklist, monitoring plan, deployment, rollback, troubleshooting, and interview notes.

## Quick start
1. Read `infrastructure/terraform/README.md` and `docs/deployment-steps.md`.
2. Confirm your AWS account, region, supported EKS version, budget, and permissions.
3. Run Terraform `init`, `validate`, `plan`; review carefully before `apply`.
4. Set up GitHub OIDC and a least-privilege deployment role.
5. Configure EKS access for the deployment role and push to `main`.
6. Install the AWS Load Balancer Controller and configure CloudWatch collection.
7. Test app endpoints, scaling, failure recovery, and rollback.
8. Destroy resources after the lab and confirm billable resources are gone.

## Important limitations
This is a learning starter, not a one-click production deployment. The GitHub OIDC role, EKS deployment authorization, AWS Load Balancer Controller installation, CloudWatch add-on/configuration, ACM certificate, and SNS alarm actions require account-specific setup. Verify current AWS-supported Kubernetes versions and official installation instructions before deployment. Review all Terraform plans and costs.

## Cost and security warning
EKS, worker EC2 instances, NAT Gateway, ALB, CloudWatch ingestion, and data transfer can incur charges. The Terraform example uses one NAT Gateway to reduce lab costs, which is not a highly available production configuration. Do not commit credentials, state files, kubeconfig, or secrets. Destroy resources after testing.
