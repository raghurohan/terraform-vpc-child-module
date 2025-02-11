output "az_info" {
    value = data.aws_availability_zones.available.names
}

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