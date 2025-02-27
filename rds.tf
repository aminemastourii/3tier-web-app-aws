resource "aws_db_instance" "rds" {
  allocated_storage      = 10
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "root"
  password               = "12345678"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-rds-az1.id, aws_subnet.private-subnet-rds-az2.id] #AWS will create automatically the rds in one of these two subnets , and its standBy in the other subnet 

  tags = {
    Name = "My RDS Subnet Group"
  }
  
}
