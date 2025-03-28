# AWS Private EKS Cluster with Internal ALB, VPN Gateway, and Terraform

## Overview
This project provisions a **private Amazon EKS cluster** with the following components:
- **Internal ALB (Application Load Balancer)** to handle internal traffic.
- **Private VPC** with public and private subnets.
- **AWS Client VPN Gateway** to securely access the private cluster.
- **Route 53 DNS** for internal service discovery.
- **Terraform** for infrastructure as code.

## Architecture Diagram
```
                     +----------------------+    
                     |   AWS Client VPN    |    
                     +----------+-----------    
                                |    
                                v    
+-------------------------------------------+
|         Private VPC                       |
| +---------------------------------------+ |
| | Private Subnets                       | |
| | +---------------------+ +-----------+ | |
| | | Internal ALB        | |   EKS     | | |
| | | (Nginx Ingress)     | |  Cluster  | | |
| | +---------------------+ +-----------+ | |
| | Route 53 Private DNS                    |
| +---------------------------------------+ |
+-------------------------------------------+
```

## Modules Structure
```
modules
├── alb         # Internal ALB setup
├── dns         # Private Route 53 DNS
├── eks         # EKS Cluster in private subnet
├── vpc         # VPC, subnets, NAT, IGW
└── vpn         # Client VPN Gateway for private cluster access
```

## Prerequisites
- Terraform installed (`>=1.0`)
- AWS CLI configured
- IAM user with necessary permissions

## Deployment Instructions

### Step 1: Initialize Terraform
```sh
terraform init
```

### Step 2: Plan Deployment
```sh
terraform plan
```

### Step 3: Apply Changes
```sh
terraform apply -auto-approve
```

### Step 4: Configure VPN Access
After deployment, configure your local machine to connect to the VPN using the generated `.ovpn` file.

## Accessing the Private EKS Cluster
### Connect to VPN
```sh
openvpn --config your-vpn-config.ovpn
```

### Verify Cluster Access
```sh
aws eks update-kubeconfig --region us-east-1 --name my-cluster
kubectl get nodes
```

## Outputs
After successful deployment, Terraform provides:
- **EKS Cluster Name**
- **VPN Endpoint**
- **ALB DNS Name (Internal)**
- **Private Route 53 Hosted Zone**

## Cleanup
To destroy the infrastructure, run:
```sh
terraform destroy -auto-approve
```

---
This project enables **secure access to a private EKS cluster** using **VPN and an internal ALB**, ensuring **no public exposure** while allowing controlled internal traffic. 🚀

