## Destroy-Safe Workflow

This EKS stack is intended to be **ephemeral**: spin it up for testing during the day, then tear it down cleanly to avoid idle AWS cost. The critical point is that Kubernetes objects can create AWS resources outside Terraform’s direct control during runtime. If those objects are still present when `terraform destroy` runs, destroy may fail, hang, or leave billable resources behind.

### Why order matters

The cluster may dynamically create or attach:

- Application Load Balancers (Application Load Balancers)
- Network Load Balancers (Network Load Balancers)
- Amazon Elastic Block Store volumes through Persistent Volume Claims
- Elastic Network Interfaces
- security group dependencies

Terraform can destroy only what it knows how to detach in the correct order. If Kubernetes still owns cloud resources, the dependency graph can become stuck.

---

## Daily teardown sequence

### 1. Remove workload-level AWS resource consumers first

Delete any Kubernetes objects that cause AWS infrastructure to exist outside the base cluster.

Typical examples:

- `Service` objects of type `LoadBalancer`
- `Ingress` objects managed by AWS Load Balancer Controller
- `PersistentVolumeClaim` objects that dynamically provision Amazon Elastic Block Store volumes
- `StatefulSet` workloads still holding attached storage
- test namespaces containing deployed applications

Examples:

```bash
kubectl delete ingress --all -A
kubectl delete svc --all -A
kubectl delete pvc --all -A
kubectl delete statefulset --all -A
```

Be more selective in real use if needed. The main goal is to remove objects that provision or hold cloud resources.

---

### 2. Wait for cloud-backed resources to actually disappear

Do not immediately destroy the cluster after deleting Kubernetes objects. Confirm that the external resources are gone.

Check:

```bash
kubectl get ingress -A
kubectl get svc -A
kubectl get pvc -A
kubectl get pv
```

Also verify in AWS that these are disappearing:

- Load Balancers
- target groups
- Amazon Elastic Block Store volumes created for test claims
- network interfaces associated with deleted workloads

This wait step is important because Kubernetes deletion is asynchronous.

---

### 3. Uninstall optional add-ons that create or manage AWS resources

If installed through Helm or manifests, remove add-ons that may continue reconciling cloud resources.

Common examples:

- AWS Load Balancer Controller
- Karpenter
- ingress controllers
- external-dns
- Prometheus / Grafana stacks if you want a fully clean in-cluster shutdown

Examples:

```bash
helm uninstall aws-load-balancer-controller -n kube-system
helm uninstall karpenter -n kube-system
```

Not every add-on must be uninstalled before destroy, but anything that actively creates or reconciles AWS resources should be removed first.

---

### 4. Scale active workloads down if needed

If you are not deleting namespaces entirely, scale down Deployments, StatefulSets, and Jobs so pods terminate and detach from nodes cleanly.

Examples:

```bash
kubectl scale deployment --all --replicas=0 -A
kubectl scale statefulset --all --replicas=0 -A
```

This is especially useful before removing storage-backed workloads.

---

### 5. Drain or reduce node usage if you are validating a quiet shutdown

If desired, reduce node group size before full destroy. This is optional, but it can help expose stuck pods, Pod Disruption Budget issues, or volume-detach problems before Terraform starts deleting infrastructure.

---

### 6. Run `terraform destroy`

Once workload-created resources are gone and controllers are no longer reconciling, destroy the infrastructure.

Example:

```bash
terraform destroy \
  -var-file=environment/dev/account.tfvars \
  -var-file=environment/dev/us-east-2/regional.tfvars \
  -var-file=global/global.tfvars \
  -var-file=environment/dev/us-east-2/terraform.auto.tfvars
```

---

## Practical teardown checklist

Use this checklist at end of day:

- Delete `Ingress` resources
- Delete `Service` resources of type `LoadBalancer`
- Delete `PersistentVolumeClaim` resources you do not want to keep
- Delete or scale down test workloads
- Uninstall AWS-integrated controllers if they were installed
- Wait for Load Balancers, target groups, and Amazon Elastic Block Store volumes to disappear
- Run `terraform destroy`
- Confirm no leftover billable resources remain in AWS

---

## Common failure modes

### `terraform destroy` hangs on security groups or subnets
This usually means a Load Balancer, target group, or network interface still exists.

### Node group or cluster deletion stalls
This can happen when pods are still running, finalizers remain, or storage is still attached.

### Amazon Elastic Block Store volumes remain after cluster deletion
This usually means the Persistent Volume or StorageClass reclaim behavior did not remove the backing volume, or the claim was not deleted first.

### AWS Load Balancer Controller recreates resources during teardown
This happens if the controller is still running while `Ingress` or `Service` objects still exist.

---

## Recommended operating rule

For this stack, always treat Kubernetes workloads as the **first teardown boundary** and Terraform infrastructure as the **second teardown boundary**:

1. delete workload-created resources  
2. wait for AWS cleanup  
3. destroy Terraform infrastructure

That order is the safest and most repeatable way to avoid orphaned cost.

> End-of-day rule: delete Kubernetes objects that create AWS resources first, wait for those resources to disappear, then run `terraform destroy`. Do not destroy the cluster while `Ingress`, `Service type LoadBalancer`, or `PersistentVolumeClaim` resources are still active.
