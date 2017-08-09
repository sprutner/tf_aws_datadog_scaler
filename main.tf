### Auto Scaling ###

## SNS ##
# SNS Topic for the ASG trigger
resource "aws_sns_topic" "autoscaling" {
  name = "${var.name}-autoscaling"
}

# Subscribe Lambda to the SNS Topic
resource "aws_sns_topic_subscription" "autoscaling" {
  topic_arn = "${aws_sns_topic.autoscaling.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.autoscaling.arn}"
}

## Lambda ##
# Lambda Policy for autoscaling
resource "aws_iam_role" "autoscaling_trust" {
  name                = "${var.environment}-${var.name}-tf-iam-role-autoscaling-trust"
  assume_role_policy  = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "autoscaling" {
    name   = "tf_lambda_vpc_policy_${var.name}"
    path   = "/"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Effect": "Allow",
    "Action": [
        "autoscaling:*"
    ],
        "Resource": "*"
      }
    ]
}
EOF
}

#attach the permissions to the lambda policy
resource "aws_iam_policy_attachment" "autoscaling" {
    name       = "tf-iam-role-attachment-${var.name}-lambda-autoscaling-policy"
    roles      = ["${aws_iam_role.autoscaling_trust.name}"]
    policy_arn = "${aws_iam_policy.autoscaling.arn}"
}


# Lambda function for triggering an ASG event from SNS
resource "aws_lambda_function" "autoscaling" {
    filename          = "${path.module}/autoscaling.py.zip"
    function_name     = "${var.environment}-${var.name}-autoscaling"
    runtime           = "python2.7"
    timeout           = "30"
    role              = "${aws_iam_role.autoscaling_trust.arn}"
    handler           = "autoscaling.lambda_handler"
    source_code_hash  = "${base64sha256(file("${path.module}/autoscaling.py.zip"))}"
}

# Permission for SNS to trigger function
resource "aws_lambda_permission" "allow_autoscaling" {
  statement_id   = 45
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.autoscaling.function_name}"
  principal      = "sns.amazonaws.com"
  source_arn     = "${aws_sns_topic.autoscaling.arn}"
}

# Autoscaling Policies
resource "aws_autoscaling_policy" "out" {
  name                   = "${upper(var.environment)}-${var.name}_asg_policy_out"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${var.asg_name}"

  step_adjustment {
    scaling_adjustment = 1
    metric_interval_lower_bound = 0
    metric_interval_upper_bound = 20
  }

  step_adjustment {
    scaling_adjustment = 2
    metric_interval_lower_bound = 20
  }
}

resource "aws_autoscaling_policy" "in" {
  name                   = "${upper(var.environment)}-${var.name}_asg_policy_in"
  policy_type            = "StepScaling"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${var.asg_name}"

  step_adjustment {
    scaling_adjustment = -1
    metric_interval_lower_bound = -20
    metric_interval_upper_bound = 0
  }

  step_adjustment {
    scaling_adjustment = -2
    metric_interval_upper_bound = -20
  }
}

# Datadog Monitors for the ASG

#Scale Out
resource "datadog_monitor" "asg_mem_low" {
  depends_on         = ["aws_lambda_function.autoscaling"]
  name               = "${upper(var.environment)}-${var.scale_out_monitor_name}"
  type               = "metric alert"
  message            = "@sns-${aws_sns_topic.autoscaling.name} 1\n${var.name} ${var.asg_name} ${aws_autoscaling_policy.out.name} 59"
  escalation_message = "@sns-${aws_sns_topic.autoscaling.name} 1\n${var.name} ${var.asg_name} ${aws_autoscaling_policy.out.name} 59"

  query = "avg(last_1m):${var.out_avg_by}:system.mem.free{autoscaling_group:${lower(var.asg_name)}} < ${var.out_critical_threshold}"

  thresholds {
    ok       = "${var.out_ok_threshold}"
    warning  = "${var.out_warning_threshold}"
    critical = "${var.out_critical_threshold}"
  }

  notify_no_data    = false
  renotify_interval = "${var.out_renotify_interval}"
  require_full_window = false

  notify_audit = false
  include_tags = true

  tags = ["environment:${var.environment}"]
  }

#Scale in
resource "datadog_monitor" "asg_mem_high" {
  depends_on         = ["aws_lambda_function.autoscaling"]
  name               = "${upper(var.environment)}-${var.scale_in_monitor_name}"
  type               = "metric alert"
  message            = "@sns-${aws_sns_topic.autoscaling.name} 1\n${var.name} ${var.asg_name} ${aws_autoscaling_policy.in.name} 41"
  escalation_message = "@sns-${aws_sns_topic.autoscaling.name} 1\n${var.name} ${var.asg_name} ${aws_autoscaling_policy.in.name} 41"

  query = "avg(last_5m):${var.in_avg_by}:${var.query_metric}{autoscaling_group:${lower(var.asg_name)}} > ${var.in_critical_threshold}"

  thresholds {
    ok       = "${var.in_ok_threshold}"
    warning  = "${var.in_warning_threshold}"
    critical = "${var.in_critical_threshold}"
  }

  notify_no_data    = false
  renotify_interval = "${var.in_renotify_interval}"
  require_full_window = false

  notify_audit = false
  include_tags = true

  tags = ["environment:${var.environment}"]
  }
