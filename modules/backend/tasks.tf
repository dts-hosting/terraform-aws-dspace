resource "aws_cloudwatch_event_rule" "this" {
  for_each = local.tasks

  name                = "${local.name}-${each.key}"
  schedule_expression = each.value.schedule
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = local.tasks

  target_id = "${local.name}-${each.key}"
  arn       = local.cluster_id
  rule      = aws_cloudwatch_event_rule.this[each.key].name
  role_arn  = aws_iam_role.this.arn

  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "LATEST"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.this["cli"].arn

    network_configuration {
      assign_public_ip = local.assign_public_ip
      security_groups  = [local.security_group_id]
      subnets          = local.subnets
    }
  }

  input = <<DOC
{
  "containerOverrides": [
    {
      "name": "cli",
      "command": ${jsonencode(each.value.args)}
    }
  ]
}
DOC
}
