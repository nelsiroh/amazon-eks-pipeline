# amazon-eks-pipeline
Amazon EKS multi-environment pipeline with ArgoCD

## Aether Nubis LLC
A cloud consulting company.  "Aether Nubis" is **Latin** for "Ether of the Clouds".  
AetherNubis LLC is cloud technology consulting company specializing in helping companies of all sizes navigate uncertainty to bring thier products to the cloud.

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
### Why this design is better

1. Environment Comes First = Human Clarity
```
Putting dev/ first means engineers can quickly find the relevant files for an environment they’re working on:

environment/
├── dev/
│   ├── us-east-1/
│   ├── us-east-2/
│   └── us-west-2/
├── staging/
├── prod/

This is how most teams think: “I’m working in dev, what region config do I need?”

If you flip it to:

environment/us-east-2/dev/

Then engineers must look through regions first and hope the environment exists there. That’s cognitively harder and not how people plan infra.
```
2. Enables Clean Dev/Stage/Prod Workflows
```
You likely want:

    Different variables per environment

    Same regional support per environment

By putting dev/ first, it implies a full replica of the project structure per environment — which helps you guarantee parity across environments.

It also makes automation and CI/CD workflows easier:

for env in dev staging prod; do
  terraform plan -var-file=environment/$env/us-east-2/terraform.auto.tfvars
done
```
3. Follows Terraform Best Practices
```
HashiCorp itself shows examples and tutorials that prioritize environment-first patterns.

See the Terraform documentation and examples and patterns from real-world multi-env repos — they all tend to follow the:

environment/<env>/<region>/... pattern.
```
4. It’s Easier to Template and Scale
```
If you later want to make a Terraform wrapper script or module generator, this is easier:

ENV=$1
REGION=$2
TFVARS="environment/${ENV}/${REGION}/terraform.auto.tfvars"

than needing to reverse REGION/ENV.
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
