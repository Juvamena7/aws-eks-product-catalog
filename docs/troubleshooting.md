# Troubleshooting guide

| Symptom | Checks | Typical fix |
|---|---|---|
| GitHub workflow cannot assume role | OIDC provider, role trust `sub`, audience, repository/branch | Correct trust policy; do not add permanent access keys |
| ECR push denied | ECR repository policy and IAM actions | Grant push actions only on the target repository |
| `kubectl` unauthorized | EKS access entry/access policy and Kubernetes RBAC | Grant least-privilege deployment permissions |
| Pods in `ImagePullBackOff` | `kubectl describe pod`, image URI/tag, node network | Fix image URI/tag, registry access, or node egress |
| Pods in `CrashLoopBackOff` | `kubectl logs --previous`, events, app config | Fix app error or probe/configuration issue |
| ALB not created | Controller logs, IAM role, subnet tags, Ingress events | Fix controller permissions and subnet tags |
| ALB target unhealthy | Target group health, Service endpoints, health path/port | Ensure `/healthz` responds and Service selectors match |
| HPA shows unknown CPU | `kubectl top pods`, metrics API, CPU requests | Fix metrics-server/metrics pipeline and resource requests |
| Rollout stalls | `kubectl rollout status`, events, readiness probes | Correct image/config/probes or roll back |
| Terraform key/version/network issue | `terraform plan`, supported EKS versions, AWS account/region | Correct variables and rerun plan before apply |

Useful commands:
```bash
kubectl get events -n product-catalog --sort-by=.lastTimestamp
kubectl describe pods -n product-catalog
kubectl logs deployment/product-catalog -n product-catalog --tail=100
kubectl logs deployment/product-catalog -n product-catalog --previous
kubectl get endpoints product-catalog -n product-catalog
kubectl rollout history deployment/product-catalog -n product-catalog
```
