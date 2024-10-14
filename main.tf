resource "aws_eks_cluster" "new_eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
  }

  tags = var.cluster_tags
}

resource "aws_launch_template" "EKS_NG_Template" {
  for_each = var.nodegroup_templates

  name     = each.value.name
  key_name = each.value.key_name

  tag_specifications {
    resource_type = "instance"
    tags          = each.value.tags_instance
  }

  tag_specifications {
    resource_type = "volume"
    tags          = each.value.tags_volume
  }

  tag_specifications {
    resource_type = "network-interface"
    tags          = each.value.tags_network
  }
}

resource "aws_eks_node_group" "new_eks_node_group" {
  for_each = { for nodegroup in var.nodegroup_configs : nodegroup.name => nodegroup }

  cluster_name    = aws_eks_cluster.new_eks_cluster.name
  node_group_name = each.value.name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = each.value.subnets
  ami_type        = each.value.ami_type
  capacity_type   = each.value.capacity_type
  instance_types  = [each.value.instance_type]

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  launch_template {
    id      = aws_launch_template.EKS_NG_Template[lookup(var.nodegroup_template_mapping, each.value.name)].id
    version = each.value.launch_template_version
  }

  labels = each.value.labels
  tags   = each.value.tags
}
