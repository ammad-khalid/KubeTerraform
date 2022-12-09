resource "aws_eks_cluster" "dev-eks" {
  name     = "dev-eks"
  role_arn = aws_iam_role.aws-eks-ammad-dev.arn

  vpc_config {
    subnet_ids = [aws_subnet.dev-subnet-priv-1.id, aws_subnet.dev-subnet-priv-2.id ]
    /*cluster_security_group_id = "${aws_security_group.kubernetes.id}"*/
  }

  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}
