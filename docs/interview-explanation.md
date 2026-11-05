# Interview explanation

## 60–90 second project summary
“I built an end-to-end CI/CD workflow for a containerized Product Catalog application on Amazon EKS. Developers push code to GitHub, and GitHub Actions checks out the code, builds and smoke-tests a Docker image, authenticates to AWS using GitHub OIDC, pushes a commit-tagged image to Amazon ECR, and deploys that version to EKS. The application runs with three replicas in private worker subnets behind a Kubernetes Service and an AWS Application Load Balancer managed by the AWS Load Balancer Controller. I configured readiness and liveness probes, CPU requests and limits, an HPA, CloudWatch logging/monitoring, and a documented rollout rollback process. I also focused on least-privilege IAM, Kubernetes RBAC, and keeping secrets out of Git.”

Only claim tasks you have actually implemented and tested. Describe unimplemented sections as planned or in progress.

## Why each service is used
- GitHub: source control and pull requests.
- GitHub Actions: automated build, test, image push, and deployment.
- Docker: packages the app and runtime consistently.
- ECR: private, versioned container image registry with scan-on-push.
- EKS: managed Kubernetes control plane for container orchestration.
- Private subnets: keep worker nodes off direct public internet ingress.
- ALB + AWS Load Balancer Controller: external HTTP routing to pod IP targets.
- Deployment: maintains desired replicas and performs rolling updates.
- Service: stable in-cluster endpoint for matching pods.
- Probes: readiness gates traffic; liveness restarts unhealthy containers.
- HPA: adjusts replica count based on observed CPU utilization.
- CloudWatch: central logs, metrics, dashboards, and alarms.
- IAM/OIDC: authenticate GitHub Actions without long-lived AWS keys.
- Kubernetes RBAC: limit what a deployment identity can do in the cluster.

## Failure scenario
“If a deployment becomes unhealthy, I check rollout status, pod events, current and previous logs, and readiness/liveness probe results. If the new version cannot become healthy, I stop treating it as a successful release and roll back to the last known-good image or Deployment revision. Then I verify replica readiness and the ALB target health, inspect CloudWatch logs/alarms, and document the root cause.”
