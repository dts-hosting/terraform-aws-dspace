resource "aws_appautoscaling_target" "this" {
  max_capacity       = local.autoscaling_max_capacity
  min_capacity       = 1
  resource_id        = local.autoscaling_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  name               = local.name
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  service_namespace  = aws_appautoscaling_target.this.service_namespace
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = local.autoscaling_cpu_threshold
  }
}

# TODO: other policies may be added in the future
