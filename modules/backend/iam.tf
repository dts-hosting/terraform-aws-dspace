resource "aws_iam_role" "this" {
  name = var.name
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "ecs.amazonaws.com",
          "ecs-tasks.amazonaws.com",
          "events.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole",
      "Sid": ""
    }
  ]
}
EOF

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonECS_FullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]

  inline_policy {
    name = "ECSTaskPassRole"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["iam:PassRole"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}
