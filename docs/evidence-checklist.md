# Evidence checklist

Capture screenshots/output for:
- [ ] `terraform plan` reviewed (redact account identifiers if sharing publicly)
- [ ] EKS nodes and their private subnet placement
- [ ] ECR repository with immutable commit-tagged image and scan status
- [ ] Successful GitHub Actions workflow
- [ ] Three or more Ready pods and Service endpoints
- [ ] ALB Ingress hostname and healthy target group
- [ ] `/` and `/api/products` responding through ALB
- [ ] HPA output and a controlled load test in the lab
- [ ] CloudWatch log stream, dashboard, and alarm state
- [ ] Deliberately failed rollout followed by successful rollback
- [ ] Cleanup confirmation: no unwanted NAT Gateway, ALB, EKS, EC2, or EBS resources
