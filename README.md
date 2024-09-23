# Coalfire techical chaallenge completed by Aliia Abdrakhmanova
# Proof-of-Concept Environment with Terraform in AWS

This repository contains Terraform code to set up a proof-of-concept environment in AWS. The infrastructure consists of networking, compute resources, an application load balancer, auto-scaling group, and S3 buckets, with lifecycle policies for storage.

## Architecture Overview
- 1 VPC with 4 subnets: 2 public (sub1, sub2)and 2 private (sub3, sub4)
- 1 EC2 instance in a public subnet (sub2)
- 1 Auto Scaling Group (ASG) spanning private subnets (sub3 and sub4) with Apache web servers
- 1 Application Load Balancer (ALB) listening on HTTP port 80 and forwarding traffic to ASG on port 443
- IAM roles for S3 access and logging
- 2 S3 buckets with lifecycle policies

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your machine
- AWS account credentials with permissions to create the required resources
- SSH access to EC2 instances
- GitHub repository with your working Terraform code

## Usage Instructions

1. Clone the repository:
    ```
    git clone https://github.com/your-username/aws-poc-terraform.git
    cd aws-poc-terraform /////
    ```
2.  Create $FILENAME.tfvars in configurations folder
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


3. Update the `terraform.tfvars` file with your configuration values (ensure no sensitive information is committed).

4. Initialize Terraform:
    ```
    terraform init
    ```

5. Validate the configuration:
    ```
    terraform validate
    ```

6. Apply the configuration:
    ```
    terraform apply (terraform apply -var-file=$DATAFILE)
    ```

7. SSH into the EC2 instance in sub2:
    ```
    ssh -i <your-key-name> ec2-user@<EC2-public-IP>
    ```

8. After applying, visit the ALB endpoint to verify that the Apache web servers are running

## References

- [Coalfire AWS Terraform Modules](https://github.com/orgs/Coalfire-CF/repositories?type=public&q=terraform-aws)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform AWS Modules] (https://registry.terraform.io/browse/modules)


