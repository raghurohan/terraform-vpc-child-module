# creating a vpc root module

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

#internet gateway

resource "aws_internet_gateway" "igw" {
  vpc = aws_vpc.main.id
   tags = {
    Name = var.vpc_name
  }

}

resource "aws_subnet" "public" {
  count = length(var.public_cidr)
  vpc_id = aws_vpc.main.id
  cidr_blocks = var.public_cidr[count.index]
  availability_zones = local.availability_zones
  map_public_ip_on_launch = true
  tags = {
    Name = "public-${var.vpc_name}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_cidr)
  vpc_id = aws_vpc.main.id
  cidr_blocks = var.private_cidr[count.index]
  availability_zones = local.availability_zones
  tags = {
    Name = "private-${var.vpc_name}"
  }
}

resource "aws_subnet" "database" {
  count = length(var.databse_cidr)
  vpc_id = aws_vpc.main.id
  cidr_blocks = var.database_cidr[count.index]
  availability_zones = local.availability_zones
  tags = {
    Name = "database-${var.vpc_name}"
  }
}

resource "aws_db_subnet_group" "default" {
  subnet_id = aws_subnet.database[*].id
  tags = {
    Name = "${var.vpc_name}-dev"
  }

resource "aws_eip" "nat" {
  vpc = true
}
}

# NAT gateway : one interesting fact about nat gateway is , it has to be placed in PUBLIC subnets to provide secure internet 
# connection for private and database subnets. why becuase nat gateway access internet gateway and igw is in public subnet;
# nat gateway has to created only after interet gateway is created . so we should explicitely mention that. 
resource "aws_nat_gateway" "main" {
  subnet_id = aws_subnet.public[0].id
  allocation_id =  aws_eip.nat.id
  tags = {
    Name = "${var.vpc_name}-dev"
  }

  depends_on = [aws_internet_gateway.igw]
}



#route table and its route 

resource "aws_route_table" "public" {
vpc_id = aws_vpc.main.id

  route {
   route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-dev-public"
  }
}

#############################
resource "aws_route_table" "private" {
vpc_id = aws_vpc.main.id

  route {
    route_table_id            = aws_route_table.private.id
    destination_cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-dev-private"
  }
}

#############################
resource "aws_route_table" "database" {
vpc_id = aws_vpc.main.id

   route {
    route_table_id            = aws_route_table.database.id
    destination_cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.vpc_name}-dev-database"
  }
}

###################################
  resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)
  subnet_id      = aws_subnet.public[*].id
  route_table_id = aws_route_table.public.id
}

###################################
  resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)
  subnet_id      = aws_subnet.private[*].id
  route_table_id = aws_route_table.private.id
}

###################################
  resource "aws_route_table_association" "database" {
  count = length(var.database_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}