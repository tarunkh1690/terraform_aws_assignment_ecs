data "aws_ecs_task_definition" "supermarket-app-service" {
  task_definition = aws_ecs_service.supermarket-app-service.task_definition
}

# output "certificaea" {
#   value = aws_acm_certificate.my_certificate.arn
# }