# Deployment rollback

## Roll back Kubernetes Deployment
```bash
kubectl rollout history deployment/product-catalog -n product-catalog
kubectl rollout undo deployment/product-catalog -n product-catalog
kubectl rollout status deployment/product-catalog -n product-catalog
```

## Roll back to a specific revision
```bash
kubectl rollout history deployment/product-catalog -n product-catalog
kubectl rollout undo deployment/product-catalog --to-revision=2 -n product-catalog
```

## CI/CD rollback approach
Every build is tagged with the full Git commit SHA. To roll back, redeploy a previously tested ECR image tag using `kubectl set image`, then verify the rollout and application endpoint. Do not rely on `latest` for rollback because it is mutable and ambiguous.

## Test a failed rollout safely
In a non-production lab only, use an intentionally invalid image tag and observe the rollout stall:
```bash
kubectl set image deployment/product-catalog product-catalog=invalid.example/no-image:bad -n product-catalog
kubectl rollout status deployment/product-catalog -n product-catalog --timeout=60s
kubectl rollout undo deployment/product-catalog -n product-catalog
```
The invalid image test is expected to fail; immediately undo it and verify all replicas become Ready again.
