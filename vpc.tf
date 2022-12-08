resource "aws_vpc" "dev-vpc" {
    cidr_block = "10.101.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    instance_tenancy = "default"

    tags = {
        Name = "${var.env}-vpc"
    }
}

/*resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    enable_classiclink = "false"
    instance_tenancy = "default"

    tags = {
        Name = "prod-vpc"
    }
}*/

resource "aws_subnet" "dev-subnet-public" {
    vpc_id = "${aws_vpc.dev-vpc.id}"
    cidr_block = "10.101.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "${var.env}-subnet-public"
}

/*
resource "aws_subnet" "private" {
  for_each                = var.priv_subnet
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = each.key
  }
}
*/



}
resource "aws_subnet" "dev-subnet-priv-1" {
    vpc_id = "${aws_vpc.dev-vpc.id}"
    cidr_block = "10.101.2.0/24"
    map_public_ip_on_launch = "true" 
    availability_zone = "eu-west-1b"

    tags = {
        Name = "${var.env}-subnet-priv-1"
}
}
resource "aws_subnet" "dev-subnet-priv-2" {
    vpc_id = "${aws_vpc.dev-vpc.id}"
    cidr_block = "10.101.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1c"

    tags = {
        Name = "${var.env}-subnet-priv-2"
}


}
resource "aws_db_subnet_group" "db-private-subnet" {
    name = "db-subnet-group"
    subnet_ids = ["${aws_subnet.dev-subnet-priv-1.id}","${aws_subnet.dev-subnet-priv-2.id}"]
    
    }


resource "aws_flow_log" "vpcflowlogs" {
  log_destination      = aws_s3_bucket.s3bucket-ammad.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.dev-vpc.id
}

resource "aws_flow_log" "publicflowlogs" {
  log_destination      = aws_s3_bucket.s3bucket-ammad.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  subnet_id            = aws_subnet.dev-subnet-public.id
}
resource "aws_flow_log" "priv1flowlogs" {
  log_destination      = aws_s3_bucket.s3bucket-ammad.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  subnet_id            = aws_subnet.dev-subnet-priv-1.id
}
resource "aws_flow_log" "priv2flowlogs" {
  log_destination      = aws_s3_bucket.s3bucket-ammad.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  subnet_id            = aws_subnet.dev-subnet-priv-2.id
}

