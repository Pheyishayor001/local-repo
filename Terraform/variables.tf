#Network Variables
variable "region" {
  description = "region"
  type        = string
  default     = ""
}

variable "AZs" {
  description = "Availability Zones"
  type        = list(string)
  default     = []
}

variable "VPC_CIDR_block" {
  type        = string
  description = "CIDR block"
  default     = ""
}
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  #Using two CIDR block to enable AWS create a replica of the Db in another AZ
  default     = [] 
}

#EC2 Instance variables
# key pair - Location to the SSH Key generate using openssl or ssh-keygen or AWS KeyPair
variable "ssh_file" {
  description = "Path to an SSH public key"
  default     = ""
}

variable "AMI" {
  description = "AMI"
  default     = "" 
}

variable "instance_type" {
  description = "Instance type"
  default = ""
}

variable "root_volume_size" {
  type    = number
  default =  8
}


### DB VARIABLES
variable "db_engine" {
  description = "db engine"
  default = ""
}
variable "db_instance_class" {
  description = "db instance class"
  default = ""
}
variable "db_storage" {
  description = "db storage"
  default =  8
}
variable "db_user" {
  description = "db user"
  default = ""
}
variable "db_password" {
  description = "db pasword"
  default = ""
}
variable "db_name" {
  description = "db name"
  default = ""
}