resource "aws_cloudwatch_log_group" "supermarket-app-logs" {
  name = "/ecs/example-container-logs"  # Replace with your desired log group name
}