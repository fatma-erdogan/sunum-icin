

resource "aws_vpc" "vpc" {

  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"                      = "${var.project}-${var.env}"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = " ${var.project}-${var.env} "
  }
}

###### subnets  #######
resource "aws_subnet" "az1-public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.az1-public-sb-cidr
  availability_zone       = var.az1
 

  tags = {
    "Name" = "${var.az1}-public"
    "type" = "public"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az1-private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az1-private1-sb-cidr
  availability_zone = var.az1
  

  tags = {
    "Name" = "${var.az1}-private-1"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az1-private2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az1-private2-sb-cidr
  availability_zone = var.az1
 
  tags = {
    "Name" = "${var.az1}-private-2"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az1-private3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az1-private3-sb-cidr
  availability_zone = var.az1
  

  tags = {
    "Name" = "${var.az1}-private-3"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az2-public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.az2-public-sb-cidr
  availability_zone       = var.az2
  
  tags = {
    "Name" = "${var.az2}-public"
    "type" = "public"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az2-private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az2-private1-sb-cidr
  availability_zone = var.az2
  

  tags = {
    "Name" = "${var.az2}-private-1"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az2-private2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az2-private2-sb-cidr
  availability_zone = var.az2
  
  tags = {
    "Name" = "${var.az2}-private-2"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az2-private3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az2-private3-sb-cidr
  availability_zone = var.az2
  

  tags = {
    "Name" = "${var.az2}-private-3"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az3-public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.az3-public-sb-cidr
  availability_zone       = var.az3
  

  tags = {
    "Name" = "${var.az3}-public"
    "type" = "public"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az3-private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az3-private1-sb-cidr
  availability_zone = var.az3
  

  tags = {
    "Name" = "${var.az3}-private-1"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.project}-${var.env}"      = "shared"
  }

}

resource "aws_subnet" "az3-private2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az3-private2-sb-cidr
  availability_zone = var.az3
  

  tags = {
    "Name" = "${var.az3}-private-2"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "shared"
  }

}

resource "aws_subnet" "az3-private3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.az3-private3-sb-cidr
  availability_zone = var.az3
  
  tags = {
    "Name" = "${var.az3}-private-3"
    "type" = "private"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "shared"
  }

}

###### Elastik=ip ####
resource "aws_eip" "nat-1" {
  vpc = true
}

resource "aws_eip" "nat-2" {
  vpc = true
}

resource "aws_eip" "nat-3" {
  vpc = true
}


######## NAT GATEWAYS ########

resource "aws_nat_gateway" "nat-1" {
  allocation_id = aws_eip.nat-1.id
  subnet_id     = aws_subnet.az1-public.id
  depends_on    = [aws_internet_gateway.eks-igw]
  tags = {
    "Name" = "${var.project}-${var.env}-${var.az1}-nat"
  }
}
resource "aws_nat_gateway" "nat-2" {
  allocation_id = aws_eip.nat-2.id
  subnet_id     = aws_subnet.az2-public.id
  depends_on    = [aws_internet_gateway.eks-igw]
  tags = {
    "Name" = "${var.project}-${var.env}-${var.az2}-nat"
  }
}
resource "aws_nat_gateway" "nat-3" {
  allocation_id = aws_eip.nat-3.id
  subnet_id     = aws_subnet.az3-public.id
  depends_on    = [aws_internet_gateway.eks-igw]
  tags = {
    "Name" = "${var.project}-${var.env}-${var.az3}-nat"
  }
}


####### ROUTE TABLES ######

resource "aws_route_table" "private-1" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-${var.project}-${var.env}-${var.az1}"
  }
}
resource "aws_route_table" "private-2" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-${var.project}-${var.env}-${var.az2}"
  }
}
resource "aws_route_table" "private-3" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-${var.project}-${var.env}-${var.az3}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }
  tags = {
    Name = "${var.project}-${var.env}-public"
  }
}


######### ROUTE TABLES ASSOSIATIONS #####

###### ROUTES #######
resource "aws_route" "private_nat_gateway-1" {
  route_table_id         = aws_route_table.private-1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-1.id
}

resource "aws_route" "private_nat_gateway-2" {
  route_table_id         = aws_route_table.private-2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-2.id
}

resource "aws_route" "private_nat_gateway-3" {
  route_table_id         = aws_route_table.private-3.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-3.id
}

###### PRIVATE ASSOSIATIONS ########

resource "aws_route_table_association" "az1-private1" {
  subnet_id      = aws_subnet.az1-private1.id
  route_table_id = aws_route_table.private-1.id
}

resource "aws_route_table_association" "az1-private2" {
  subnet_id      = aws_subnet.az1-private2.id
  route_table_id = aws_route_table.private-1.id
}

resource "aws_route_table_association" "az1-private3" {
  subnet_id      = aws_subnet.az1-private3.id
  route_table_id = aws_route_table.private-1.id
}
resource "aws_route_table_association" "az2-private1" {
  subnet_id      = aws_subnet.az2-private1.id
  route_table_id = aws_route_table.private-2.id
}
resource "aws_route_table_association" "az2-private2" {
  subnet_id      = aws_subnet.az2-private2.id
  route_table_id = aws_route_table.private-2.id
}
resource "aws_route_table_association" "az2-private3" {
  subnet_id      = aws_subnet.az2-private3.id
  route_table_id = aws_route_table.private-2.id
}

resource "aws_route_table_association" "az3-private1" {
  subnet_id      = aws_subnet.az3-private1.id
  route_table_id = aws_route_table.private-3.id
}
resource "aws_route_table_association" "az3-private2" {
  subnet_id      = aws_subnet.az3-private2.id
  route_table_id = aws_route_table.private-3.id
}
resource "aws_route_table_association" "az3-private3" {
  subnet_id      = aws_subnet.az3-private3.id
  route_table_id = aws_route_table.private-3.id
}

####### PUBLIC ASSOSIATIONS ######
resource "aws_route_table_association" "az1-public" {
  subnet_id      = aws_subnet.az1-public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "az2-public" {
  subnet_id      = aws_subnet.az2-public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "az3-public" {
  subnet_id      = aws_subnet.az3-public.id
  route_table_id = aws_route_table.public.id
}
