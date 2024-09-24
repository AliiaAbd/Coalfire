
# Coalfire AWS Proof-of-Concept Environment using Terraform

This repository contains the Terraform code to set up a proof-of-concept AWS environment as part of Coalfire technical task. The infrastructure consists of networking, compute resources, an auto-scaling group (ASG) with Apache web servers, an application load balancer (ALB), and S3 buckets with lifecycle policies.

---

## Overview

This project uses **Terraform** to automate the deployment of the following AWS resources:
- A Virtual Private Cloud (VPC) with four subnets: two public(sub1/sub2) and two private (sub3/sub4)
- A standalone EC2 instance Red Hat Linux in a public subnet for testing purposes.
- An Auto Scaling Group (ASG) deployed across private subnets (sub3/sub4) with Red Hat Linux instances running Apache.
- An Application Load Balancer (ALB) to distribute traffic across the ASG.
- Two S3 buckets:
  - **Images Bucket** with a lifecycle policy to move objects older than 90 days to Glacier.
  - **Logs Bucket** with lifecycle policies to archive and delete logs based on age.
  
The solution uses Coalfire's open-source Terraform modules, Terraform modules, AWS Documentation.

---



## Prerequisites

- **Terraform**: You need to have Terraform installed on your local machine. You can download it from [here](https://www.terraform.io/downloads.html).
- **AWS Credentials**: Make sure your AWS CLI is configured with credentials that have permissions to create the resources in your account. You can configure your AWS CLI using:
  ```bash
  aws configure
  
  An existing key pair in the AWS region you're working in, or create a new one to use for SSH access to the EC2 instance.
  
  ## Usage
Clone the repository and navigate into the directory
```
git clone https://github.com/your-username/aws-poc-terraform.git
cd aws-poc-terraform

```
Create $FILENAME.tfvars in configurations folder

```
aws_region           = "us-east-1"
# VPC values
name                = " coalfire"
vpc_cidr             = "10.1.0.0/16"
azs                  = ["us-east-1a", "us-east-1b"]
private_subnets      = ["10.1.2.0/24", "10.1.3.0/24"]
public_subnets       = ["10.1.0.0/24", "10.1.1.0/24"]
enable_nat_gateway   = true

#EC2 values
instance_name        = "coalfire"
ami                  = "ami-0583d8c7a9c35822c"  
instance_size        = "t2.micro"
instance_volume_size = 20 
instance_count       = 1
key_name             = "my-laptop-key"
associate_public_ip  = true 
# Global tags for the EC2 instance and other resources
global_tags = {
  Name        = "ec2-instance"
  Environment = "Production"
  Project     = "AWS-POC"
}

# # Root volume size for the EC2 instance
root_volume_size = "20"
subnet_ids = [
  "subnet-04b486e155b69d468",
  "subnet-0eade075f5f4e30fd"
]
ebs_optimized = false
```
## Note
Using pre-commit helps automate and enforce code quality checks before commits are made to a Git repo
```
pre-commit run --all-files
```
## Deployment
To deploy everything, use the following commands:

terraform init
terraform validate
terraform plan
terraform apply (terraform apply -var-file coalfire.tfvars)

## Outputs
Once the deployment is successful, Terraform will display outputs, including:

Public Subnets: Lists the public subnet IDs.
Private Subnets: Lists the private subnet IDs.
EC2 Public IP: The public IP address of the EC2 instance in Sub2. ## you may add this line
ALB DNS: The DNS name for the Application Load Balancer. ##you may add this line

## Example
Outputs:

public_subnets = [
  "subnet-04b486e155b69d468",
  "subnet-0eade075f5f4e30fd"
]
private_subnets = [
  "subnet-03b486e155b69e567",
  "subnet-0fad075f5f4e40gh"
]
ec2_public_ip = "54.123.45.67"
alb_dns_name = "my-alb-1234567890.us-east-1.elb.amazonaws.com"

## References
Terraform AWS Provider Documentation https://registry.terraform.io/browse/modules
Coalfire AWS Terraform Modules https://github.com/orgs/Coalfire-CF/repositories?type=public&q=terraform-aws
AWS S3 Lifecycle Policy Documentation https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html
