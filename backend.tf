# S3 Bucket for Images
module "images_bucket" {
  source = "github.com/Coalfire-CF/terraform-aws-s3"

  name = "images-bucket-coalfire"
    providers = {
    aws = aws.eu_west_1  # Use the aliased provider for the correct region
  }
  

  enable_lifecycle_configuration_rules = true

  lifecycle_configuration_rules = [
    {
      id      = "MoveMemesToGlacier"
      prefix  = "Memes/"  # Applies to objects in the Memes folder
      enabled = true

      enable_glacier_transition = true
      glacier_transition_days   = 90  # Move objects to Glacier after 90 days

    }
  ]

  enable_kms                    = false
  enable_server_side_encryption = false
  
}

# S3 Bucket for Logs
module "logs_bucket" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-s3.git"

  name = "logs-bucket-coalfire"
  
  providers = {
    aws = aws.eu_west_1  # Ensure the correct provider alias is used
  }

  enable_lifecycle_configuration_rules = true

  lifecycle_configuration_rules = [
    {
      id      = "MoveActiveToGlacier"
      prefix  = "Active/"  # Applies to objects in the Active folder
      enabled = true

      enable_glacier_transition = true
      glacier_transition_days   = 90  # Move objects to Glacier after 90 days

    },
    {
      id      = "DeleteInactiveAfter90Days"
      prefix  = "Inactive/"  # Applies to objects in the Inactive folder
      enabled = true

      expiration_days = 90  # Delete objects after 90 days
    }
  ]

  enable_kms                    = false
  enable_server_side_encryption = false
}