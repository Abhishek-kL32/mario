############################################
# uber-prod VPC                            #
############################################

resource "aws_vpc" "myapp_vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.project_name}-${var.project_env}"
  }
}


############################################
# uber-prod Internet Gateway               #
############################################

resource "aws_internet_gateway" "myapp_igw" {
  vpc_id = aws_vpc.myapp_vpc.id

  tags = {
    Name = "${var.project_name}-${var.project_env}"
  }
}

############################################
# uber-prod Elastic IP                     #
############################################

resource "aws_eip" "myapp_eip" {

  domain = "vpc"
  tags = {
    Name = "${var.project_name}-${var.project_env}-eip"
  }
}


############################################
# uber-prod Public-subnet's                #
############################################

resource "aws_subnet" "public-1" {
  vpc_id                                      = aws_vpc.myapp_vpc.id
  cidr_block                                  = var.public_subnet-1
  availability_zone                           = "${var.region}a"
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.project_env}-public-1"
  }
}


resource "aws_subnet" "public-2" {
  vpc_id                                      = aws_vpc.myapp_vpc.id
  cidr_block                                  = var.public_subnet-2
  availability_zone                           = "${var.region}b"
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.project_env}-public-2"
  }
}

resource "aws_subnet" "public-3" {
  vpc_id                                      = aws_vpc.myapp_vpc.id
  cidr_block                                  = var.public_subnet-3
  availability_zone                           = "${var.region}c"
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.project_env}-public-3"
  }
}

############################################
# uber-prod Private-subnets                #
############################################

resource "aws_subnet" "private-1" {
  vpc_id            = aws_vpc.myapp_vpc.id
  cidr_block        = var.private_subnet-1
  availability_zone = "${var.region}a"

  tags = {
    Name = "${var.project_name}-${var.project_env}-private-1"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.myapp_vpc.id
  cidr_block        = var.private_subnet-2
  availability_zone = "${var.region}b"

  tags = {
    Name = "${var.project_name}-${var.project_env}-private-2"
  }
}

resource "aws_subnet" "private-3" {
  vpc_id            = aws_vpc.myapp_vpc.id
  cidr_block        = var.private_subnet-3
  availability_zone = "${var.region}c"

  tags = {
    Name = "${var.project_name}-${var.project_env}-private-3"
  }
}


############################################
# uber-prod Nat-Gateway                    #
############################################

resource "aws_nat_gateway" "myapp_nat" {
  allocation_id = aws_eip.myapp_eip.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "${var.project_name}-${var.project_env}-NAT-gateway"
  }

  depends_on = [aws_internet_gateway.myapp_igw]
}



############################################
# uber-prod Public-route_Table             #
############################################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp_igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-public-route_table"
  }
}


############################################
# uber-prod Private-route_Table            #
############################################

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.myapp_nat.id
  }

  tags = {
    Name = "${var.project_name}-${var.project_env}-private-route_table"
  }
}


###############################################
# uber-prod Public-RouteTbl-association       #
###############################################

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = aws_subnet.public-3.id
  route_table_id = aws_route_table.public.id
}

###############################################
# uber-prod Private-RouteTbl-association       #
###############################################

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-3" {
  subnet_id      = aws_subnet.private-3.id
  route_table_id = aws_route_table.private.id
}


