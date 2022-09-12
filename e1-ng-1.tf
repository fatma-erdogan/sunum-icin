#Create AWS EKS Node Group - Public
resource "aws_eks_node_group" "eks-ngrp-1" {
  cluster_name    = aws_eks_cluster.eks_cluster.name

  node_group_name = "${var.project}-${var.env}-ngrp-1"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = [
    aws_subnet.az1-private1.id,
    aws_subnet.az1-private2.id,
    aws_subnet.az1-private3.id,
    aws_subnet.az2-private1.id,
    aws_subnet.az2-private2.id,
    aws_subnet.az2-private2.id,
    aws_subnet.az3-private1.id,
    aws_subnet.az3-private2.id,
    aws_subnet.az3-private3.id
  ]
  #version = var.cluster_version #(Optional: Defaults to EKS Cluster Kubernetes version)    
  
  ami_type = "AL2_x86_64"  
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = ["t3.medium"]
  
  
  remote_access {
    ec2_ssh_key = "eks-terraform-key"
    #source_security_group_ids = 
  }

  scaling_config {
    desired_size = 1
    min_size     = 1    
    max_size     = 3
  }

  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1    
    #max_unavailable_percentage = 50    # ANY ONE TO USE
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly-2,
    aws_iam_role_policy_attachment.eks-AmazonElasticFileSystemReadOnlyAccess,
   
  ] 

  tags = {
    Name = "${var.project}-${var.env}-ngrp-1"
  }

# labels to instruct Kubernetes scheduler to use a particular node group by using affinity
                        #means for node selactor for pods 
#   labels = {
#     role = "general"  
#   }


#  # taints allow a node to repel a set of pods 
# taint {
#     key = "team"
#     value = "qa"
#     effeffect = "NO_SCHEDULE"}


### pod a bakan kismi ise 
# tolerations:
# - key : tem 
#   operator : equal
#   value : devops
#   effect : NoSchedule

 ### in case we want to create a custom configuration for our k8s nodes , we can use the lauch-template
# launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

}


# resource "aws_launch_template" "eks-with-disks" {
#   name = "eks-with-disks"

#   key_name = "local-provisioner"

#   block_device_mappings {
#     device_name = "/dev/xvdb"

#     ebs {
#       volume_size = 50
#       volume_type = "gp2"
#     }
#   }
# }
