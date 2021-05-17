provider "aws" {
  region  = "us-east-1"
  version = "2.68.0"
}

module "module_1" {
  source  = "registry.acquia.io/accounts"
  version = "0.1.0"
}
