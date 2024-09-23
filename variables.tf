variable "aws_region" {
  description = "ID of AMI to use for the instance"
  type        = string
}
#VPC values
variable "name" {
  description = "The name of the VPC"
  type        = string
  default     = "coalfire"  # You can replace the default with your preferred VPC name
}
variable "vpc_cidr" {
  description = "The name of the VPC"
  type        = string
}  
variable "private_subnets" {
  description = "The name of the VPC"
  type        = list(string)
}  

variable "public_subnets" {
  description = "The name of the VPC"
  type        = list(string)
}  
variable "enable_nat_gateway" {
  description = "The name of the VPC"
  type        = bool
}  
variable "azs" {
  description = "The name of the VPC"
  type        = list(string)
}  
variable "tags" {
  description = "The name of the VPC"
  type        = map(string)
  default = {
    "name" = "VPC"
  }
}  
variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
  default     = 1
}


variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "instance_name" {
  description = "The name of the ec2 instance"
  type        = string
}

variable "instance_size" {
  description = "The type of instance to start"
  type        = string
}

variable "key_name" {
  description = "The key name to use for the instance key pair"
  type        = string
}

variable "root_volume_type" {
  description = "The type of the root ebs volume on the ec2 instances created"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "The size of the root ebs volume on the ec2 instances created"
  type        = string

}

variable "instance_volume_size"{
    description = "value"
    type = number
    
}
variable "global_tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "test"
    Project     = "POC"
  }
}
variable "subnet_ids" {
  description = "List of subnet IDs to associate with the EC2 instance"
  type        = list(string)
}


