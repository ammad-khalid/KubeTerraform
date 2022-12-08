resource "aws_eks_cluster" "dev-eks" {
  name     = "dev-eks"
  role_arn = aws_iam_role.aws-eks-ammad-dev.arn

  vpc_config {
    subnet_ids = [aws_subnet.dev-subnet-priv-1.id, aws_subnet.dev-subnet-priv-2.id ]
    /*cluster_security_group_id = "${aws_security_group.kubernetes.id}"*/
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}



/*output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}*/
