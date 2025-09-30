resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  vpc_id        = aws_vpc.main.id #requestor
  peer_vpc_id   = data.aws_vpc.default.id #acceptor
  
  auto_accept   = true

  
}


resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}

resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}


resource "aws_route" "default_peering" { #from default vpc to our custom vpc connection
  count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_route_table.main.route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[count.index].id
}


########## here i am trying something new , adding data source block also here and also variable block required 
# for peering connection

# data "aws_vpc" "default" { # to get default vpc details where we need vpc id
#   default = true
# }

# data "aws_route_table" "main"{  # to get default or main route table id of default vpc
#   vpc_id = data.aws_vpc.default.id
#   filter {
#     name = "association.main"
#     values = ["true"]
#   }
# }

variable "is_peering_required" {
  description = "Flag to enable/disable peering connection"
  type        = bool
  default     = false
}
