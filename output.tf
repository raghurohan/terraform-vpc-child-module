output "az_info" {
    value = data.aws_availability_zones.available.names
}