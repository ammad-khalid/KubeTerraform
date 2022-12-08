resource "aws_eks_node_group" "nodegroup00" {
  cluster_name    = aws_eks_cluster.dev-eks.name
  node_group_name = "nodegroup00"
  node_role_arn   = aws_iam_role.aws-eks-ammad-dev-noderole.arn
  subnet_ids      = [ aws_subnet.dev-subnet-priv-1.id, aws_subnet.dev-subnet-priv-2.id ]
  ami_type = "${var.AMI_TYPE}"
  /*remote_access_security_group_id = ["${aws_security_group.kubernetes.id}"]*/
  instance_types = ["${var.instance_type}"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryFullAccess,
  ]
}
