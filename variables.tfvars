# --var-file=variables.tfvars

private_subnets = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
public_subnets = ["172.18.4.0/24", "172.18.5.0/24", "172.18.6.0/24"]
cidr = "172.18.0.0/16"
min_capacity = 1
max_capacity = 3
desired_capacity = 1
region   = "eu-west-2"