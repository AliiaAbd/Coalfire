# # module "ec2_test" {
# #   source = "github.com/Coalfire-CF/terraform-aws-ec2"

# #   name = var.instance_name
   

# #   ami               = var.ami
# #   ec2_instance_type = var.instance_size
# #   instance_count    = var.instance_count

# #   vpc_id = module.vpc.vpc_id
# #   subnet_ids = module.vpc.subnet_id[1]

# #   ec2_key_pair    = var.key_name
# #   ebs_kms_key_arn = ""

# #   # Storage
# #   root_volume_type = var.instance_volume_type
# #   root_volume_size = var.instance_volume_size

# #   # Security Group Rules
# #     ingress_rules = {
# #     "ssh" = {
# #       ip_protocol = "tcp"
# #       from_port   = "22"
# #       to_port     = "22"
# #       cidr_ipv4   = ["0.0.0.0/0"] #?    
# #       description = "Allow SSH"
# #     }
# #     ingress_rules = {  # ingress dynamic 
# #     "http" = {
# #       ip_protocol = "tcp"
# #       from_port   = "80"
# #       to_port     = "80"
# #       cidr_ipv4   = ["0.0.0.0/0"] 
# #       description = "Allow HTTP access"
# #      }
    
# #     }

# #     egress_rules = {
# #     "allow_all_egress" = {
# #       ip_protocol = "-1"
# #       from_port   = "0"
# #       to_port     = "0"
# #       cidr_ipv4   = "0.0.0.0/0"
# #       description = "Allow all egress"
# #      }
# #     }

# #   # Tagging
# # #    global_tags = {
# # #     Name        = "${var.name}-ec2-instance"
# # #     Environment = "stage"
# # #     Project     = "coalfire"
# # #   }
# # }
# # } 

# # #create account in Red HAD Account ,install yum package
module "ec2_test" {
  source = "github.com/Coalfire-CF/terraform-aws-ec2"
ebs_optimized = false 
  name = var.instance_name

  ami               = var.ami
  ec2_instance_type = var.instance_size
  instance_count    = var.instance_count

  # Reference the VPC module properly
  vpc_id     = module.vpc.vpc_id
  subnet_ids = var.subnet_ids

  ec2_key_pair    = var.key_name
  ebs_kms_key_arn = ""  # Specify if needed, else leave blank

  # Storage
  root_volume_size = var.instance_volume_size
 # Associate Public IP
  associate_public_ip = true  # Ensure the instance gets a public IP
  # Security Group Rules - fixed cidr_ipv4 to be a string
  ingress_rules = {
    "ssh" = {
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow SSH access"
    },
    "http" = {
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow HTTP access"
    }
  }

  egress_rules = {
    "allow_all_egress" = {
      ip_protocol = "-1"
      from_port   = 0
      to_port     = 0
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all egress"
    }
  }

  # Tagging
  global_tags = var.global_tags
}

