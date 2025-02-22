resource "aws_launch_template" "auto_scale" {
  name_prefix   = "auto_scale-"
  image_id      = var.AMI  # Uses same AMI as default ec2
  instance_type = var.instance_type #same instance type

  network_interfaces {
    security_groups             = [aws_security_group.ec2_Public_SG.id]
    associate_public_ip_address = true
  }

  lifecycle {
    create_before_destroy = true # ensures tf creates a new resource before destroying the old. to ensure zero downtime
  }
}

resource "aws_autoscaling_group" "app_ASG" {
  name_prefix         = "app_ASG-"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = aws_subnet.public_subnet[*].id  # List of subnet IDs

  launch_template {
    id      = aws_launch_template.auto_scale.id
    version = "$Latest"
  }

  tag {
    key                 = "app_ASG"
    value               = "app_ASG-instance"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  autoscaling_group_name = aws_autoscaling_group.app_ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  autoscaling_group_name = aws_autoscaling_group.app_ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2 #number of times to evaluate
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120 #secs
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_ASG.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up.arn] #trigger scale-up
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2 #number of times to evaluate
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120 #secs
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_ASG.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down.arn] # trigger scale-up
}
