module "Project_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "project-VPC"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform = "true"
  }

  
}

resource "aws_security_group_rule" "supermarket-appegress-rule" {
  type        = "egress"
  from_port   = 0              # Starting port for the rule
  to_port     = 65535          # Ending port for the rule
  protocol    = "tcp"          # Protocol for the rule (e.g., tcp, udp, icmp, etc.)
  cidr_blocks = ["0.0.0.0/0"]  # IP range to allow outbound traffic to (0.0.0.0/0 allows all outbound traffic)
  security_group_id = module.Project_vpc.default_security_group_id
}


resource "aws_security_group_rule" "supermarket-app-8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  security_group_id = module.Project_vpc.default_security_group_id
}

resource "aws_security_group_rule" "supermarket-app-3389_public" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.Project_vpc.default_security_group_id
}

resource "aws_security_group_rule" "supermarket-app-8080_public" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.Project_vpc.default_security_group_id
}





