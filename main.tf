data "aws_availability_zones" "azs" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.product}-${var.environment}-vpc"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}


/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "${var.product}-${var.environment}-igw"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name      = "${var.product}-${var.environment}-nat-eip"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.product}-${var.environment}-public-route-table"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.ig.id
}

/* creating public application subnet in availability zone a */
resource "aws_subnet" "public_app_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_app_subnet_cidr_a
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name          = "${var.product}-${var.environment}-public-app"
    AZName          = "${var.product}-${var.environment}-public-app-subnet-a"
    Product       = var.product
    ENV           = var.environment
    Terraform     = true
  }
}

/* Associating the public subnet a with the public route table */
resource "aws_route_table_association" "public_app_route_subnet_assoc_a" {
  subnet_id      = aws_subnet.public_app_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

# /* creating public application subnet in availability zone b */
resource "aws_subnet" "public_app_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_app_subnet_cidr_b
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name         = "${var.product}-${var.environment}-public-app"
    AZName         = "${var.product}-${var.environment}-public-app-subnet-b"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

/* NAT Gatway for private subnet outbound request over the net */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_app_subnet_a.id
}

/* Routing table for private subnet */
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.product}-${var.environment}-private-route-table"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}
/* routing private subnet output calls through the NAT Gateway */
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}



# /* creating private database subnet in availability zone a */
resource "aws_subnet" "private_db_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_db_subnet_cidr_a
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.product}-${var.environment}-private-db"
    AZName        = "${var.product}-${var.environment}-private-db-subnet-a"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

resource "aws_route_table_association" "private_db_route_subnet_assoc_a" {
  subnet_id      = aws_subnet.private_db_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

# /* creating private database subnet in availability zone b */

resource "aws_subnet" "private_db_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_db_subnet_cidr_b
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.product}-${var.environment}-private-db"
    AZName        = "${var.product}-${var.environment}-private-db-subnet-b"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

resource "aws_route_table_association" "private_db_route_subnet_assoc_b" {
  subnet_id      = aws_subnet.private_db_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}


# /* creating private database subnet in availability zone c */
resource "aws_subnet" "private_db_subnet_c" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_db_subnet_cidr_c
  availability_zone       = data.aws_availability_zones.azs.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.product}-${var.environment}-private-db"
    AZName        = "${var.product}-${var.environment}-private-db-subnet-c"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

resource "aws_route_table_association" "private_db_route_subnet_assoc_c" {
  subnet_id      = aws_subnet.private_db_subnet_c.id
  route_table_id = aws_route_table.private_route_table.id
}


resource "aws_security_group" "capstone-simple-app-secgroup" {
  name = "CapstoneSimpleSecgroup"
  description = "This is a simple security group for http and https access"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow connection to http 80"
  }

  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow connection to ssl port"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "capstone-simple-db-secgroup" {
  name        = "${var.product}-${var.environment}-mysql-secgroup"
  description = "Allow all inbound traffic to mysql db"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = "tcp"
    security_groups = [aws_security_group.capstone-simple-app-secgroup.id]
    description     = "Allow App secgroup to the DB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.product}-${var.environment}-mysql-secgroup"
    Product     = var.product
    ENV         = var.environment
    Terraform   = true
  }
}

# This is just for introductory concepts. I would not do this for production or shared projects
resource "aws_key_pair" "capstone-key-pair" {
  key_name = "CapstoneIndentity"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4cF7vD3LqmJrrwsRseh8NVdYv7qeRlvSVDHtinVmo8kUI7q8SvSGynqoZidRQzTbrnUEbnjnCOx+/6raQKMrtdQPGkAg3X5xUVUArvWjJ+Dy6GUmcK+GJZaF9fGiGO1Ep6dOVr6BlksbOZjHJDzLnJuJnSs4JgJFafw3scGVUV/8W4oQLq1DYaCMaqOgFkrcJPi0GbfEga9LLsQ+DWjOG+SpYscLc8ShVrEazro6BQMcWiwpQXS3hZ1C55bYtNNkY7//quTFj5BOHPGKT7IHTbYegjALf15Gk+d9UvTs2eWar8qY38XvRTmZD5CXwVYiY+9b5HiJJpKfK6wvnPJMo+PtQziX6u3P7uha+uXDXBESEZh8hFWv4sddtV/qCu+wN3C7d2mQXUAkDBcq0an3gZ/3lE5OVJP6mIT2PduuH4pKZwRPo3qxtkEgHIxfOj7ETMYdYIHeL0ZTc7ac6Yn7enXFqTV7mgOiiBymsC1Mko2X2nWB9tebuH2zXuYgL9YDrfo+AD1E0o4aTgfSozTcnYAVtg1e3SEsE5nbiKIxkN74YtmDiKjnjSMXE1H0+8n982U9WYnN9t1UpHoIubhwc4irEX0dbeUiKK6qovu+lVgWSYmUOHEJHvBfNXwIMxRivw6hmX/n5T7XyY75lkn+WiPLVIenVXX7+PngkguaptQ== capstone-identity"
}

resource "aws_instance" "capstone-single" {
  ami = "ami-085925f297f89fce1"
  instance_type = "t2.micro"
  count = 1
  vpc_security_group_ids = [aws_security_group.capstone-simple-app-secgroup.id]
  subnet_id = aws_subnet.public_app_subnet_a.id
  user_data = file("files/ubuntu_cloud_init.sh")
  key_name = aws_key_pair.capstone-key-pair.key_name
  associate_public_ip_address = true

  tags = {
    Name = "CapstonInstance"
    AZName = "CapstoneInstance-${element(data.aws_availability_zones.azs.names,count.index )}"
    Env  = "Test"
    Product = "Capstone"
    Terraform = true
  }
}


resource "aws_db_subnet_group" "rds_subnetgroup" {
  name       = "${var.product}-${var.environment}-${var.rds_subnetgroupname}"
  subnet_ids = ["${aws_subnet.private_db_subnet_a.id}",
                "${aws_subnet.private_db_subnet_b.id}",
                "${aws_subnet.private_db_subnet_c.id}"]

  tags = {
    Name = "${var.product}-${var.environment}-${var.rds_subnetgroupname}"
    Product     = var.product
    Terraform   = true
  }
}

resource "aws_db_parameter_group" "rds_paramgroup" {
  name   = "${var.product}-${var.environment}-${var.rds_paramgroupname}"
  family = "mysql5.7"

  tags = {
    Name        = "${var.product}-${var.environment}-${var.rds_paramgroupname}"
    Product     = var.product
    Terraform   = true
  }
}


resource "aws_db_instance" "mysql_instance" {
  allocated_storage         = var.rds_storage_size
  storage_type              = var.rds_storage_type
//  backup_retention_period   = var.rds_bak_retention
  engine                    = var.rds_engine
  engine_version            = var.rds_engine_version
  instance_class            = var.rds_instance_size
  identifier                = "${var.product}-${var.environment}-${var.rds_name}"
  username                  = var.rds_root_username
  password                  = var.rds_root_password
  parameter_group_name      = aws_db_parameter_group.rds_paramgroup.id
  db_subnet_group_name      = aws_db_subnet_group.rds_subnetgroup.id
  vpc_security_group_ids    = [aws_security_group.capstone-simple-db-secgroup.id]
  multi_az                  = var.rds_multi_az
  port                      = var.mysql_port
  skip_final_snapshot       = false
  final_snapshot_identifier = "${var.rds_name}-final-snapshot"

  tags = {
    Name      = "${var.product}-${var.environment}-${var.rds_name}"
    Product     = var.product
    Terraform   = true
  }
}
