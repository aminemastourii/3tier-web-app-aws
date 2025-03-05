# Deploying a Scalable Web Application on AWS with Terraform

This repository contains Terraform scripts to deploy a scalable and resilient web application on AWS. The infrastructure is designed for high availability, security, and automation using AWS services.

## 🏗 Architecture Overview
This Terraform configuration sets up the following components:

- **VPC & Networking**: Configures a VPC with public and private subnets across multiple availability zones, NAT gateways, and an internet gateway.
- **Security**: Defines security groups for EC2, ALB, and RDS to ensure secure access control.
- **Application Deployment**: Uses EC2 instances in an Auto Scaling group to ensure availability and resilience.
- **Load Balancer**: Implements an Application Load Balancer (ALB) to distribute traffic and manage SSL termination via ACM.
- **Database**: Deploys an Amazon RDS instance with a standby replica for high availability.
- **Monitoring & Notifications**: Uses SNS for Auto Scaling notifications and alerts.
- **Domain Management**: Configures Route 53 for DNS management of the custom domain.

## 🛠 Prerequisites
Before deploying this infrastructure, ensure you have the following:

- **Terraform** installed ([Download Terraform](https://developer.hashicorp.com/terraform/downloads))
- **AWS CLI** configured ([Setup AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- An AWS account with necessary permissions
- A registered domain in Route 53 (optional, but recommended)

## 🚀 Deployment Steps
Follow these steps to deploy the infrastructure:

### 1️⃣ Clone the Repository
```bash
git clone git@github.com:aminemastourii/3tier-web-app-aws.git
cd your-repo-folder
```

### 2️⃣ Initialize Terraform
```bash
terraform init
```
This command initializes Terraform and downloads required providers.

### 3️⃣ Preview Changes
```bash
terraform plan
```
This shows the planned execution before making any changes.

### 4️⃣ Deploy the Infrastructure
```bash
terraform apply -auto-approve
```
Terraform will create all the resources defined in the configuration.

### 5️⃣ Verify Deployment
- Check the **AWS Console** to confirm the resources are deployed.
- Retrieve the ALB DNS name using:
  ```bash
  terraform output alb_dns_name
  ```
- Visit the provided ALB URL to test the application.

## 🧹 Cleanup
To destroy all resources and prevent charges, run:
```bash
terraform destroy -auto-approve
```

     # Documentation


## 📌 Notes
- Modify **variables.tf** to customize instance types, region, and other parameters.
- Ensure your AWS credentials are properly configured before running Terraform.

## 📞 Support
If you have any questions or issues, feel free to open an issue or reach out.

🚀 Happy Deploying!

