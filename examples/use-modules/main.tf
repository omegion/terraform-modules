provider "aws" {
  region  = "us-east-1"
  version = "2.68.0"
}

module "module_1" {
  source   = "git@github.com:omegion/terraform-modules.git//modules/module-1?ref=module-1-v0.1.0"
  variable = "module-variable-1"
}

module "module_2" {
  source   = "git@github.com:omegion/terraform-modules.git//modules/module-2?ref=module-2-v0.4.0"
  variable = "module-variable-2"
}

//module "module_3" {
//  source  = "example.com/mycompany/foo-service/aws"
//  version = "1.0.0"
//}