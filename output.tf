# Outputs the EKS cluster name
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.new_eks_cluster.name
}

# Outputs the EKS cluster endpoint
output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.new_eks_cluster.endpoint
}

# Outputs the EKS cluster ARN
output "eks_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the EKS cluster"
  value       = aws_eks_cluster.new_eks_cluster.arn
}

# Outputs the EKS cluster version
output "eks_cluster_version" {
  description = "The Kubernetes version of the EKS cluster"
  value       = aws_eks_cluster.new_eks_cluster.version
}


# Outputs the EKS cluster security group IDs
output "eks_cluster_security_group_ids" {
  description = "The security group IDs associated with the EKS cluster"
  value       = aws_eks_cluster.new_eks_cluster.vpc_config[0].security_group_ids
}

# Outputs the EKS cluster certificate authority data
output "eks_cluster_certificate_authority" {
  description = "The certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.new_eks_cluster.certificate_authority[0].data
}

# Outputs the node groups created with their names and instance types
output "eks_node_group_details" {
  description = "Details of the EKS node groups including names, instance types, and scaling configurations"
  value = {
    for nodegroup in aws_eks_node_group.new_eks_node_group :
    nodegroup.node_group_name => {
      instance_type   = nodegroup.instance_types,
      min_size        = nodegroup.scaling_config[0].min_size,
      max_size        = nodegroup.scaling_config[0].max_size,
      desired_size    = nodegroup.scaling_config[0].desired_size,
      ami_type        = nodegroup.ami_type,
      capacity_type   = nodegroup.capacity_type,
      launch_template = nodegroup.launch_template[0].id # Adjusted to access ID from the launch template object
    }
  }
}

# Outputs the ARN of the node groups
output "eks_node_group_arns" {
  description = "The ARNs of the EKS node groups"
  value       = [for ng in aws_eks_node_group.new_eks_node_group : ng.arn] # Adjusted to use the correct attribute
}




# Outputs the VPC configuration for the EKS cluster
output "eks_vpc_config" {
  description = "VPC configuration details for the EKS cluster"
  value = {
    vpc_id                 = aws_eks_cluster.new_eks_cluster.vpc_config[0].vpc_id,
    subnet_ids             = aws_eks_cluster.new_eks_cluster.vpc_config[0].subnet_ids,
    cluster_security_group = aws_eks_cluster.new_eks_cluster.vpc_config[0].cluster_security_group_id
  }
}


# Outputs Kubernetes network config service IPv4 CIDR
output "eks_service_ipv4_cidr" {
  description = "Service IPv4 CIDR block for the EKS cluster"
  value       = aws_eks_cluster.new_eks_cluster.kubernetes_network_config[0].service_ipv4_cidr
}
