variable "private_subnets" {
   description = "Private subnets IPs"
   type        = list 
   default     = []
}

variable "public_subnets" {
   description = "Private subnets IPs"
   type        = list 
   default     = []
}

variable "cidr" {
   description = "cidr"
   type        = string 
   default     = ""
}


variable "disk_size" {
   description = "Node disk size"
   type        = number 
   default     = 20
}

variable "desired_capacity" {
   description = "EKS desired number of nodes"
   type        = number 
   default     = 1
}

variable "max_capacity" {
   description = "EKS nodes number upper limit"
   type        = number 
   default     = 5
}

variable "min_capacity" {
   description = "EKS nodes lower limit"
   type        = number 
   default     = 1
}

variable "instance_types" {
   description = "EKS nodes AMI type"
   type        = list 
   default     = ["t3a.medium"]
}

variable "public_ip" {
   description = "If there is a public access to EKS nodes"
   type        = bool 
   default     = false
}

variable "principal_arn" {
   description = "Principal user ARN"
   type        = string 
   default     = "" 
}

variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  type        = string
  default     = "for i in `seq 1 120`; do wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; sleep 5; done; echo TIMEOUT && exit 1"
}

variable "wait_for_cluster_interpreter" {
  description = "Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy."
  type        = list(string)
  default     = ["/bin/sh", "-c"]
}