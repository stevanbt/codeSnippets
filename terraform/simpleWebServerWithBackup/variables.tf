variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}

variable "region" {
  description = "AWS region for hosting our your network"
  default     = "eu-west-2"
}

variable "public_key_path" {
  description = "Enter the path to the SSH Public Key to add to AWS."
  default     = "/home/steve/keys/terraform-key.pem"
}

variable "key_name" {
  description = "Key name for SSHing into EC2"
  default     = "terraform-key"
}

variable "amis" {
  description = "Base AMI to launch the instances"
  default = {
    eu-west-2 = "ami-0fbec3e0504ee1970"
  }
}

variable "mainVPC" {
  description = "The main VPC"
  default     = "10.0.0.0/16"
}

variable "prodSubnetCidr" {
  description = "Production subnet"
  default     = "10.0.1.0/24"
}

variable "allowPublicAccessCidr" {
  description = "The CIDR that is allowed to access this resource"
  default     = ["146.90.56.22/32"]
}

