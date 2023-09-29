resource "aws_ecr_repository" "supermarket-app" {
    name = "supermarket-app" # Naming my repository
    force_delete  = true

    image_scanning_configuration {
      scan_on_push = true
  }
 }

# Define a Docker image build and push as a local-exec provisioner
resource "null_resource" "docker_push" {
  triggers = {
    ecr_repository_url = aws_ecr_repository.supermarket-app.repository_url
  }

  provisioner "local-exec" {
    command = <<EOL

      # Run package build command 
      mvn clean package

      # Authenticate Docker to your ECR registry
      aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin ${aws_ecr_repository.supermarket-app.repository_url}

      #
      
      # Build the Docker image (replace with your own build command)
      docker build -t supermarket-app:${var.version} .
      
      # Tag the Docker image with the ECR repository URI
      docker tag my-java-app:latest ${aws_ecr_repository.supermarket-app.repository_url}:latest
      
      # Push the Docker image to ECR
      docker push ${aws_ecr_repository.supermarket-app.repository_url}:latest
    EOL
  }

  depends_on = [aws_ecr_repository.supermarket-app]
}
