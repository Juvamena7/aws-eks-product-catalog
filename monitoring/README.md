# CloudWatch monitoring

Recommended implementation:
1. Enable EKS control-plane logs (API, audit, authenticator, controller manager, scheduler) for troubleshooting and audit.
2. Install the Amazon CloudWatch Observability EKS add-on or the current AWS-supported CloudWatch agent/Fluent Bit configuration to collect container logs and cluster metrics.
3. Create CloudWatch dashboards for node CPU/memory, pod restarts, pending pods, deployment availability, ALB target health, HTTP 5xx, and request latency.
4. Create alarms with actionable thresholds and notifications through an SNS topic.
5. Verify logs contain no credentials, tokens, or sensitive customer data.

Example checks:
```bash
kubectl get pods -n product-catalog
kubectl describe deployment product-catalog -n product-catalog
kubectl logs deployment/product-catalog -n product-catalog --tail=100
kubectl get hpa -n product-catalog
kubectl top pods -n product-catalog
```

`kubectl top` requires metrics-server. The HPA manifest needs a functioning metrics API and CPU requests on the container (included).
