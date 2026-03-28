terraform {
  required_version = ">= 1.6.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
    }
  }

  backend "s3" {
    bucket                      = "pez-infra-tfstate"
    key                         = "tfstate/terraform.tfstate"
    endpoints                   = { s3 = "s3.eu-central-003.backblazeb2.com" }
    region                      = "eu-central-003"
    skip_credentials_validation = true
    skip_region_validation      = true
    # Credentials read from AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY env vars
  }
}

provider "cloudflare" {
  email   = local.secrets["cloudflare_email"]
  api_token = local.secrets["cloudflare_api_key"]
}
