output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_id" {
  value = aws_alb.default.id
}
