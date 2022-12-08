variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "PRIVATE_KEY_PATH" {
  default = "keypair"
}

variable "PUBLIC_KEY_PATH" {
  default = "keypair.pub"
}

variable "ubuntu" {
  default = "ubuntu"
}

variable "bucket" {
   default = "s3bucket-ammad"
}

/*variable "db_username" {
description = "rdsmaster"
}*/

variable "db_password" {
  default = "D+HUz3r2m$^5JzM&gp"
}

variable "AMI" {
/*  type = map(string)*/
  default = "ami-0de933c15c9b49fb5"
    
  } 
    
variable "env" {
  default = "dev"
}
variable "ip" {
  default = "101"
}

provider "aws" {
    region = "${var.AWS_REGION}"
}

variable "AMI_TYPE" {
  default = "AL2_x86_64" 
}

variable "instance_type" {
  default = "t3.medium"
}
/*variable "priv_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    "dev-subnet-priv-1" = {
      cidr_block        = "10.101.1.0/24"
      availability_zone = "eu-west-1a"
    }
   }
   default = {
    "dev-subnet-priv-2" = {
      cidr_block        = "10.101.2.0/24"
      availability_zone = "eu-west-1b"
    } 
  }
}
*/
