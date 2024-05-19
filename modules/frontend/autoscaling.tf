resource "aws_appautoscaling_target" "this" {
  max_capacity       = local.autoscaling_max_capacity
  min_capacity       = local.autoscaling_min_capacity
  resource_id        = local.autoscaling_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "this" {
  for_each = local.autoscaling_configuration

  name               = "${local.name}-${each.key}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = each.value.metric
    }
    target_value = each.value.threshold
  }
}
