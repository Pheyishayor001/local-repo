#Network Variables
region = "us-east-1"
AZs = ["us-east-1a", "us-east-1b"]
VPC_CIDR_block = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.2.0/24",  "10.0.4.0/24"]

##########

#EC2 Instance variables
ssh_file = "Feyi_key_pair"
AMI = "ami-04b4f1a9cf54c11d0" #Ubuntu 24.04
instance_type = "t2.micro"
root_volume_size = 8 #GB

###########
db_engine = "postgres"
db_instance_class = "db.t3.micro"
db_storage = 8 #GB (For test)
db_user = "postgres"
db_password = "postgres"
db_name = "postgres"
