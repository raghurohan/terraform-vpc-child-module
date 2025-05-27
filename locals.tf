locals  {
    availability_zones = slice(data.aws_availability_zones.available.names, 0, 2) #starts from 0th and we need 2 subnets 
}

# 👉  this selects the first 2 availability zones from the available AZs list.

# ✅ In short:

# data.aws_availability_zones.available.names = list of all AZs (like ["us-east-1a", "us-east-1b", "us-east-1c", ...])

# slice(..., 0, 2) = picks index 0 and 1, i.e., first two AZs.