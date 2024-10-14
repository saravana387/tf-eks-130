aws_region      = "eu-west-1"
cluster_name    = "DataApi-EKS-Production"
cluster_version = "1.30"


eks_role_name  = "eks-cluster-role-staging"
eksctl_version = "0.140.0"
node_role_name = "eks-nodegroup-role-staging"


subnet_ids = [
  "subnet-046a77543fabbe11c",
  "subnet-00bcc415f425106b4",
  "subnet-04bc419d7c6a648b3",
  "subnet-09eb0e4aebde67416",
  "subnet-0ae6ed38db8b1f9d0",
  "subnet-0a285fc982c977134"
]


service_ipv4_cidr = "10.100.0.0/16"

cluster_tags = {
  Environment = "new-production-1.30"
}

nodegroup_templates = {
  large = {
    name     = "EKS-NG-large-01-Template"
    key_name = "sre_ew1_linux"
    tags_instance = {
      Name                           = "eks-node-large-01"
      alpha_eksctl_io_nodegroup_name = "managed-large-01"
      alpha_eksctl_io_nodegroup_type = "managed"
    }
    tags_volume = {
      Name                           = "eks-node-large-01"
      alpha_eksctl_io_nodegroup_name = "managed-large-01"
      alpha_eksctl_io_nodegroup_type = "managed"
    }
    tags_network = {
      Name                           = "eks-node-large-01"
      alpha_eksctl_io_nodegroup_name = "managed-large-01"
      alpha_eksctl_io_nodegroup_type = "managed"
    }
  }

}
nodegroup_configs = [
  {
    name                    = "EKS-NG-large-01"
    instance_type           = "m6a.2xlarge"
    min_size                = 1
    max_size                = 5
    desired_size            = 2
    ami_type                = "AL2_x86_64"
    subnets                 = ["subnet-09eb0e4aebde67416", "subnet-0ae6ed38db8b1f9d0", "subnet-0a285fc982c977134"]
    capacity_type           = "ON_DEMAND"
    launch_template_version = "1"
    labels                  = { "nodegroup-role" = "worker", "deployment-tag" = "3.0.0" }
    tags                    = { "Environment" = "production-1.30" }
  },
]


