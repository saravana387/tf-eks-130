variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "eks_role_name" {
  description = "Name of the IAM role for the EKS cluster"
  type        = string
}

variable "eksctl_version" {
  description = "Version of eksctl used for the EKS cluster"
  type        = string

}

variable "subnet_ids" {
  description = "Subnets for EKS Cluster"
  type        = list(string)
}

variable "service_ipv4_cidr" {
  description = "Cluster service IPv4 CIDR range"
  type        = string
  default     = "10.100.0.0/16"
}

variable "cluster_tags" {
  description = "Tags for the EKS cluster"
  type        = map(string)
  default = {
    Environment = "production-1.30"
  }
}

variable "nodegroup_templates" {
  description = "Map of node group templates for large and xlarge node groups"
  type = map(object({
    name          = string
    key_name      = string
    tags_instance = map(string)
    tags_volume   = map(string)
    tags_network  = map(string)
  }))
}

variable "node_role_name" {
  description = "Name of the IAM role for the EKS node group"
  type        = string
}

variable "nodegroup_configs" {
  description = "Configuration for EKS Node Groups"
  type = list(object({
    name                    = string
    instance_type           = string
    min_size                = number
    max_size                = number
    desired_size            = number
    ami_type                = string
    subnets                 = list(string)
    capacity_type           = string
    launch_template_version = string
    labels                  = map(string)
    tags                    = map(string)
  }))
}
variable "nodegroup_template_mapping" {
  description = "Mapping between node group config names and their corresponding launch template keys"
  type        = map(string)

  default = {
    "EKS-NG-large-01" = "large",
    #  "EKS-NG-xlarge-01" = "xlarge"
  }
}


