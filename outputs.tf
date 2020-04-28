output "output_vpc_id" {
  value = aws_vpc.vpc.id
}

output "output_app_id" {
  value = aws_instance.capstone-single.*.id
}

output "output_app_ip" {
  value = aws_instance.capstone-single.*.public_ip
}


output "output_rds_endpoint" {
  value = aws_db_instance.mysql_instance.endpoint
}