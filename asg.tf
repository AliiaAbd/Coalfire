# Define the IAM role that allows access to the "images" S3 bucket
resource "aws_iam_role" "asg_iam_role" {
  name = "asg-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = var.global_tags
}

# Attach policy to the IAM role to allow read access to "images" bucket
resource "aws_iam_policy" "asg_images_bucket_policy" {
  name = "images-bucket-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      Resource = [
        "arn:aws:s3:::images",
        "arn:aws:s3:::images/*"
      ]
    }]
  })
}

# Attach IAM policy to the IAM role
resource "aws_iam_role_policy_attachment" "asg_iam_policy_attachment" {
  role       = aws_iam_role.asg_iam_role.name
  policy_arn = aws_iam_policy.asg_images_bucket_policy.arn
}

# Define a Launch Configuration with Red Hat Linux and user data script to install Apache HTTP server
resource "aws_launch_configuration" "asg_launch_config" {
  name          = "aunch-configuration"
  image_id      = var.ami  # Replace with the Red Hat Linux AMI ID
  instance_type = "t2.micro"
  key_name      = var.key_name

  iam_instance_profile = aws_iam_instance_profile.asg_instance_profile.name

  root_block_device {
    volume_size = 20
  }

  # User data script to install Apache HTTP server
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
              EOF

  security_groups = [aws_security_group.asg_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Define an IAM Instance Profile to associate the IAM Role with the ASG instances
resource "aws_iam_instance_profile" "asg_instance_profile" {
  name = "instance-profile"
  role = aws_iam_role.asg_iam_role.name
}

# Define the Auto Scaling Group across Subnet 3 and Subnet 4
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 6
  min_size             = 2
  vpc_zone_identifier  = module.vpc.private_subnets  # Subnets Subnet 3 and Subnet 4
  launch_configuration = aws_launch_configuration.asg_launch_config.id

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "asg-instance"
    propagate_at_launch = true
  }

#   tag {
#     key                 = "Environment"
#     value               = var.environment
#     propagate_at_launch = true
#   }

  force_delete = true
}

# Security group for ASG instances
resource "aws_security_group" "asg_sg" {
  name        = "asg-sg"
  description = "Security group for ASG instances"
  vpc_id      = module.vpc.vpc_id

  # Allow inbound HTTP traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.global_tags
}
