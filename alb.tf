module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "7.0.0"

  name               = "alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.private_subnets

  security_groups    = [aws_security_group.alb_sg.id]

  http_tcp_listeners = [
    {
      port     = 80
      protocol = "HTTP"
    }
  ]

  target_groups = [
    {
      name        = "asg-target-group"
      backend_protocol = "HTTPS"
      backend_port     = 443
    }
  ]
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = module.vpc.vpc_id

  # Inbound Rules: Allow HTTP and HTTPS traffic from the public internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
    description = "Allow HTTP traffic"
  }

  # Optionally, if you are using HTTPS, include this:
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from anywhere
    description = "Allow HTTPS traffic"
  }

  # Outbound Rules: Allow all outbound traffic (so the ALB can forward traffic to the ASG instances)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "ALB-SG"
    Environment = "stage"
  }
}