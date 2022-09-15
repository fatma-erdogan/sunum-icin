terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "aws" {
  region = var.region
  # access_key = var.aws_access_key_id
  # secret_key = var.aws_secret_key 
}

module "vpc" {
source = "./modules/vpc"
# region = "us-east-1"
# vpc-cidr = "10.0.0.0/16"
# project = "rzbl-02"
# env = "qa"
# az1 = "us-east-1a"
# az2 = "us-east-1b"
# az3 = "us-east-1c"
# az1-public-sb-cidr = "10.0.10.0/24"
# az1-private1-sb-cidr = "10.0.20.0/24"
# az1-private2-sb-cidr = "10.0.30.0/24"
# az1-private3-sb-cidr = "10.0.40.0/24"
# az2-public-sb-cidr = "10.0.11.0/24"
# az2-private1-sb-cidr = "10.0.21.0/24"
# az2-private2-sb-cidr = "10.0.31.0/24"
# az2-private3-sb-cidr = "10.0.41.0/24"
# az3-public-sb-cidr = "10.0.12.0/24"
# az3-private1-sb-cidr = "10.0.22.0/24"
# az3-private2-sb-cidr =  "10.0.32.0/24"
# az3-private3-sb-cidr =  "10.0.42.0/24"
}

module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.5.0"
  name = "${var.project}-${var.env}-bastion-sec-group"
  vpc_id = module.vpc.vpc-id

  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = var.bastion-host-sg-ingress-cidr-blocks

  egress_rules = ["all-all"]
  
}

resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2_public , module.vpc]
  instance = module.ec2_public.id
  vpc      = true
 
  tags = {
    "Name" = "${var.project}-${var.env}-bastion-eip"
  }
}

module "ec2_public" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = var.instance_type
  key_name               = var.instanse_keypair
  monitoring             = true
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  subnet_id              = module.vpc.sb-az1-public
  tags = {
    Name = "${var.project}-${var.env}-bastion"
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
    private_key = file("${path.module}/private-key/eks-terraform-key.pem")
   
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
