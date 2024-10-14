resource "aws_iam_role" "eks_cluster_role" {
  name               = var.eks_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json

  tags = {
    Name           = "${var.cluster_name}/ServiceRole"
    ClusterName    = var.cluster_name
    eksctl_version = var.eksctl_version
  }
}

# Attach the AmazonEKSClusterPolicy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach the AmazonEKSVPCResourceController policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_vpc_cni_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# Define the trust policy for EKS service
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "eks_node_group_role" {
  name               = var.node_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json

  tags = {
    Name        = "${var.cluster_name}/NodeGroupRole"
    ClusterName = var.cluster_name
  }
}

# Attach the AmazonEKSWorkerNodePolicy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Attach the AmazonEC2ContainerRegistryReadOnly policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_ec2_registry_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Attach the AmazonEKS_CNI_Policy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Define the trust policy for EKS node group
data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
