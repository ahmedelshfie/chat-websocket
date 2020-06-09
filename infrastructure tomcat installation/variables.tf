variable "key_name" {
  default     = "ahmed"
}

# amazon linux 2 x86_64
variable "ami" {
  default = "ami-0a040c35ca945058a"
}

variable "vpcid" {
  default = "vpc-7a6a8011"
}

variable "subnets" {
  default = ["subnet-4c2b6036", "subnet-8d9e2dc1", "subnet-98baa8f0"]
}

variable "inst_type" {
  default = "t2.micro"
}

variable "s3bucket" {
  default = "tomcat-terraform"
}

# Access the ec2 instance remotely to run ansible; user and key:
variable "ssh_user" {
  default = "ubuntu"
}
variable "ssh_key_private" {
  default = "C:/Users/Ahmed/Desktop/Keys/ahmed.pem"
}

variable "asg_min" {
  default = "1"
}

variable "asg_max" {
  default = "2"
}

variable "asg_desired" {
  default = "1"
}

variable "health_endpoint" {
  default = "/"
}

variable "health_status_codes" {
  default = "200"
}
