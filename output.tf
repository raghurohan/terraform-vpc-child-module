output "az_info" {
    value = data.aws_availability_zones.available.names
}

output "vpc" {
    value = aws_vpc.main.id
}

output "public_subnet" {
    value = aws_subnet.public[*].id
}

output "nat" {
    value = aws_nat_gateway.main.id
}

output "eip" {
    value = aws_eip.nat.id
}