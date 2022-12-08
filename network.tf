# NATGW for private subnets

resource "aws_eip" "nat_gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.dev-subnet-public.id
  tags = {
    "Name" = "PublicNatGateway"
  }
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway.public_ip
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "privatesubnet" {
  subnet_id = aws_subnet.dev-subnet-priv-1.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "private02subnet" {
  subnet_id = aws_subnet.dev-subnet-priv-2.id
  route_table_id = aws_route_table.route.id
}


# create internet gatways

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = "${aws_vpc.dev-vpc.id}"

    tags = {
        Name = "dev-igw"
    }
}

# create a custom route table for public subnets
# public subnets can reach to the internet buy using this

resource "aws_route_table" "dev-public-crt" {
    vpc_id = "${aws_vpc.dev-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.dev-igw.id}" 
    }

    tags = {
        Name = "dev-public-crt"
    }
}

# route table association for the public subnets

resource "aws_route_table_association" "prod-crta-public-subnet-1" {
    subnet_id = "${aws_subnet.dev-subnet-public.id}"
    route_table_id = "${aws_route_table.dev-public-crt.id}"
}

# security group
resource "aws_security_group" "ssh-allowed" {

    vpc_id = "${aws_vpc.dev-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh-allowed"
    }
}

resource "aws_security_group" "db-access" {

    vpc_id = "${aws_vpc.dev-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"

        cidr_blocks = ["${aws_subnet.dev-subnet-public.cidr_block}"]
    }

    tags = {
        Name = "db-access"
    }
}
resource "aws_security_group" "kubernetes" {

    vpc_id = "${aws_vpc.dev-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"

        cidr_blocks = ["${aws_subnet.dev-subnet-public.cidr_block}","${aws_subnet.dev-subnet-priv-1.cidr_block}","${aws_subnet.dev-subnet-priv-1.cidr_block}"]
    }

    tags = {
        Name = "kubernetes"
    }
}

# create VPC Network access control list
resource "aws_network_acl" "vpcacl" {
  vpc_id = aws_vpc.dev-vpc.id
/*  subnet_ids = [ aws_subnet.dev-subnet-public.id ]*/
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0" 
    from_port  = 0
    to_port    = 65535
  }
 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

 tags =  {
    Name = "vpcacl"
}
}

resource "aws_network_acl" "subnetacl" {
  vpc_id = aws_vpc.dev-vpc.id
  subnet_ids = [ aws_subnet.dev-subnet-public.id ]
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

 tags =  {
    Name = "subnetacl"
}
}
