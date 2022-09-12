variable "vpc-region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}
variable "az1" {
  default = "us-east-1a"

}
variable "az2" {
  default = "us-east-1b"
}
variable "az3" {
  default = "us-east-1c"
}

variable "az1-public-sb-cidr" {
  default = "10.0.10.0/24"
}

variable "az1-private1-sb-cidr" {
  default = "10.0.20.0/24"
}

variable "az1-private2-sb-cidr" {
  default = "10.0.30.0/24"
}
variable "az1-private3-sb-cidr" {
  default = "10.0.40.0/24"
}

variable "az2-public-sb-cidr" {
  default = "10.0.11.0/24"
}

variable "az2-private1-sb-cidr" {
  default = "10.0.21.0/24"
}

variable "az2-private2-sb-cidr" {
  default = "10.0.31.0/24"
}
variable "az2-private3-sb-cidr" {
  default = "10.0.41.0/24"
}

variable "az3-public-sb-cidr" {
  default = "10.0.12.0/24"
}

variable "az3-private1-sb-cidr" {
  default = "10.0.22.0/24"
}

variable "az3-private2-sb-cidr" {
  default = "10.0.32.0/24"
}
variable "az3-private3-sb-cidr" {
  default = "10.0.42.0/24"
}

variable "project" {
  default = "stk"

}

variable "env" {
  default = "qa"

}

variable "cluster-name" {
  default = "eks-cluster"
}
variable "k8s-version" {
    default = "1.23"
  
}
