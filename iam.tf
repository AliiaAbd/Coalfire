# IAM Role for EC2 and ASG
resource "aws_iam_role" "ec2_asg_role" {
  name = "iam-ec2-asg"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_kms_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# S3 Access Policy (for reading and writing to the S3 buckets)
resource "aws_iam_policy" "s3_access_policy" {
  name = "s3_access_logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::logs-bucket/*"
        ]
      }
    ]
  })
}

# Attach Policies to allow access to S3
resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.ec2_asg_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
