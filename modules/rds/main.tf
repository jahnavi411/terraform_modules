resource "aws_db_instance" "rds" {
  engine = "postgres"
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  db_name = "mydatabase"
  username = "admin"
  password = "SRE@4nov2000"
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot = true
}

