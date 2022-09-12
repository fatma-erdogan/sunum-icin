variable "instance_type" {
    default = "t3.medium"
  
}

variable "instanse_keypair" {
    default = "eks-terraform-key"
  
}
output "ec2_bastion_public_instance_ids" {
    value = module.ec2_public.id
  
}
output "ec2_bastion_eip" {
    value = aws_eip.bastion_eip.public_ip
  
}


module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.5.0"
  name = "eks-bastion"
  vpc_id = aws_vpc.eks-vpc.id

  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks =["0.0.0.0/0"] 

  egress_rules = ["all-all"]
  
}
resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2_public , aws_vpc.eks-vpc]
  instance = module.ec2_public.id
  vpc      = true
 
  tags = {
    "Name" = "bastion-eip"
  }
}

module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"

  name = "demo3-single-instance"

  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = var.instance_type
  key_name               = var.instanse_keypair
  monitoring             = true
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  subnet_id              = aws_subnet.az1-public.id
  tags = {
    Name ="demo3-bastion"  ### change the name with variable 
  }
}


resource "null_resource" "copy_ec2_keys" {
  depends_on = [
    module.ec2_public
  ]
  connection {
    type = "ssh"
    host = aws_eip.bastion_eip.public_ip
    user = "ec2-user"
    password = ""
    private_key = file("private-key/eks-terraform-key.pem")
  }
  provisioner "file" {
    source = "private-key/eks-terraform-key.pem"
    destination = "/tmp/eks-terraform-key.pem"
    
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400  /tmp/eks-terraform-key.pem "
    ]
    
  }
  
}
