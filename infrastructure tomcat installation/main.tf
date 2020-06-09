provider "aws" {
  region = "us-east-2"
}
# Allowing different workspaces/envs is a good idea
locals {
  sk = "tomcat-${terraform.workspace}"
}
