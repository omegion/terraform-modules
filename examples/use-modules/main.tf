provider "aws" {
  region  = "us-east-1"
  version = "2.68.0"
}

module "module_1" {
  source  = "git@github.com:omegion/terraform-modules.git//terraform/module-1?ref=module-1-v0.3.0"
  variable = "my-variable"
}

module "module_2" {
  source  = "git@github.com:omegion/terraform-modules.git//terraform/module-1?ref=v0.3.0"
  variable = "my-variable"
}
