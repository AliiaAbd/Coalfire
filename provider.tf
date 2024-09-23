provider "aws" {
  region = var.aws_region
}
provider "aws" {
  alias  = "eu_west_1"  # Aliased provider for eu-west-1 region
  region = "eu-west-1"
}