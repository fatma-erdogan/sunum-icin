resource "aws_eks_cluster" "eks_cluster" {
    name = "${var.project}-${var.env}"
    role_arn = aws_iam_role.eks_master_role.arn
    version = var.k8s-version
    vpc_config {
      subnet_ids = [
        aws_subnet.az1-public.id,
        aws_subnet.az2-public.id,
        aws_subnet.az3-public.id,
        aws_subnet.az1-private1.id,
        aws_subnet.az1-private2.id,
        aws_subnet.az1-private3.id,
        aws_subnet.az2-private1.id,
        aws_subnet.az2-private2.id,
        aws_subnet.az2-private3.id,
        aws_subnet.az3-private1.id,
        aws_subnet.az3-private2.id,
        aws_subnet.az3-private3.id,
        ]
      endpoint_private_access = true 
      endpoint_public_access = false
    }
    kubernetes_network_config {
     service_ipv4_cidr = "172.20.0.0/16"
    }
  
  
  enabled_cluster_log_types = [ "api" , "audit" , "authenticator" , "controllerManager" , "scheduler" ]
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy ,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly ,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.eks-AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.eks-AmazonAWSAppRunnerPolicyForECRAccess,
    aws_iam_role_policy_attachment.eks-ec2-describe-policy ## this is not managed policy

  ]

}
resource "aws_eks_addon" "example" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}
resource "aws_eks_addon" "example-2" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}
resource "aws_eks_addon" "example-3" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}
