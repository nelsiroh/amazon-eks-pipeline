# amazon-eks-pipeline
Amazon EKS multi-environment pipeline with ArgoCD

## AetherNubis LLC
A cloud consulting company.  "Aether Nubis" is quasi **Greek** and **Latin** for "Sky of the Clouds".  
AetherNubis LLC is cloud technology consulting company specializing in helping companies of all sizes bring thier products to the cloud.

## Why
This is my **Marquee Project**, designed to showcase the following:
- **Cloud Infrastructure as Code:** Deploying a full AWS EKS stack using **Terraform**.
- **Automated CI/CD Pipelines:** Managing GitOps workflows using **ArgoCD**.
- **Application Deployment:** Running a **Node.js Express.js application** on Kubernetes.
- **Testing & Validation:** Utilizing **KUTTL for Kubernetes testing** and **k6 for performance testing**.
- **Scalability & Cost Efficiency:** Using **Terraform Workspaces** and **dynamic environments** for optimized resource allocation.

## Project Structure
```
├── infra                # Root Terraform configurations
├── modules              # Reusable Terraform modules
├── env                  # Environment-specific variable files 
│   └── dev
│       └── us-east-1
│           └── terraform.auto.tfvars
├── app                  # Express.js application and Jest tests
├── deploy               # Deployment manifests (e.g., ArgoCD configurations)
└── test
    ├── kuttl          # KUTTL integration tests
    └── k6             # k6 performance tests
```
## Quick Start

### Prerequisites
- **AWS CLI** installed and configured
- **Terraform** installed
- **kubectl** installed
- **ArgoCD CLI** installed
- **Docker** installed

### Deployment Steps
1. **Bootstrap Terraform Backend**
    ```bash
    ./bootstrap.sh --profile <your-aws-profile>
    ```
2. **Initialize Terraform**
    ```bash
    cd infra
    terraform init
    ```
3. **Apply Infrastructure (Creates EKS Cluster)**
    ```bash
    terraform apply -auto-approve
    ```
4. **Deploy Express.js App to Kubernetes**
    ```bash
    kubectl apply -f deploy/
    ```
5. **Verify Deployment**
    ```bash
    kubectl get pods,svc -n <namespace>
    ```
6. **Monitor in ArgoCD**
    ```bash
    argocd app get express-app
    ```
