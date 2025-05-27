# The values you are exposing from this vpc source are used when creating ec2 or may be rds or vpn etc. these values are not for VPC module; vpc module dont need this 

output "vpc" {
    value = aws_vpc.main.id
}

output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.private[*].id
}

output "mysql_subnet_ids" {
    value = aws_subnet.database[*].id
}
output "database_subnet_group" {
    value = aws_db_subnet_group.default.name
}

output "nat" {
    value = aws_nat_gateway.main.id
}

output "eip" {
    value = aws_eip.nat.id
}

output "az_info" {
    value = data.aws_availability_zones.available.names
}