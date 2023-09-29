# terraform_aws_assignment_ecs
terraform_aws_assignment_ecs

dir - 
/deployment - To create image repo in ecr and push image.
/infra - To create an ECS cluster, ALB and cloudfront.


Image Push -  To push image to ECR please follow below commands.
cd ./deployment 
update image version in deployment.tf 
terraform init
terraform validate
terraform plan
terrfaorm apply


Create ECS Cluster, ALB and Cloudfront
cd ./infra
update image version in ECS.tf @line no. 15.  
terraform init
terraform validate
terraform plan
terrfaorm apply
