
resource "aws_ecs_cluster" "supermarket-app" {
  name = "supermarket_app4" # Naming the cluster
}




resource "aws_ecs_task_definition" "supermarket-app-task" {
  family                   = "supermarket-app-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "supermarket-app-task",
      "image": "536469770717.dkr.ecr.ap-south-1.amazonaws.com/supermarket-app:v4",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ],
      "log_configuration": {
        "log_driver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.supermarket-app-logs.name}",
          "awslogs-region": "ap-south-1",
          "awslogs-stream-prefix": "example-stream-prefix"
          }
        },
      "memory": 1024,
      "cpu": 512
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 1024         # Specifying the memory our container requires
  cpu                      = 512          # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole1.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole1" {
  name               = "ecsTaskExecutionRole1"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole1.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}




resource "aws_ecs_service" "supermarket-app-service" {
  name            = "supermarket-app-service"                             # Naming our first service
  cluster         = "${aws_ecs_cluster.supermarket-app.id}"             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.supermarket-app-task.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers we want deployed to 3
  health_check_grace_period_seconds = 60
  force_new_deployment = true


  lifecycle {
    create_before_destroy = true
  }

  network_configuration {
    subnets          = ["${module.Project_vpc.private_subnets[0]}","${module.Project_vpc.private_subnets[1]}","${module.Project_vpc.private_subnets[2]}"]
    assign_public_ip = true # Providing our containers with public IPs
    security_groups = ["${module.Project_vpc.default_security_group_id}"]
  }


  load_balancer {
    target_group_arn = aws_lb_target_group.supermarket-target-group.arn
    container_name   = "supermarket-app-task"
    container_port   = 8080
 }

  depends_on = [aws_ecs_task_definition.supermarket-app-task]

}



resource "aws_lb" "supermarket-app-lb" {
  name               = "supermarket-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.Project_vpc.public_subnets
}

resource "aws_lb_target_group" "supermarket-target-group" {
  name     = "supermarket-target-group"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = "${module.Project_vpc.vpc_id}"
}

resource "aws_lb_listener" "supermarket-lb-listener" {
  load_balancer_arn = aws_lb.supermarket-app-lb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.supermarket-target-group.arn
    type             = "forward"
  }

}
