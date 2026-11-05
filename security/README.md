# Security setup checklist

## GitHub Actions to AWS
Use GitHub OIDC federation instead of long-lived AWS access keys. Create an IAM OIDC provider for `token.actions.githubusercontent.com`, then create an IAM role whose trust policy restricts the subject to your repository and `ref:refs/heads/main`. Store only the role ARN as the GitHub repository secret `AWS_GITHUB_ACTIONS_ROLE_ARN`.

The role needs narrowly scoped permissions to push to the one ECR repository and describe/update the named EKS cluster. Kubernetes authorization must also allow this role to deploy only to the intended namespace. Avoid `AdministratorAccess` for normal CI/CD.

## Kubernetes
- Use a dedicated namespace and service account.
- Keep `automountServiceAccountToken: false` unless the app needs Kubernetes API access.
- Apply least-privilege Kubernetes RBAC for humans and automation.
- Use resource requests/limits, non-root containers, read-only root filesystem, and dropped Linux capabilities.
- Do not store passwords, API keys, or certificates in Git. For production, use AWS Secrets Manager or Systems Manager Parameter Store integrated through an approved secrets operator/CSI driver.
- Use private worker nodes and restrict cluster API endpoint access to trusted networks in production.
- Enable EKS control-plane logging and audit review.

## Important
The Terraform starter intentionally does not create a GitHub OIDC role or install the AWS Load Balancer Controller. Configure both explicitly with current AWS guidance and least-privilege policies before production use.
