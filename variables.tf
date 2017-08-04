variable "name" {
  description = "Name of this datadog scaler"
}

variable "environment" {
  description = "Environment this is running in"
}

variable "asg_name" {
  descriptio = "Name of the Autoscaling Group to apply this to. "
}

variable "scale_out_monitor_name" {
  desription = "What you want to name the scale out monitor name E.G. Nomad cluster memory low"
}

variable "scale_in_monitor_name" {
  desription = "What you want to name the scale out monitor name E.G. Nomad cluster memory high"
}

## Thresholds ##

# Scaling out #
variable = "out_ok_threshold" {
  description "OK Threshold for scale_out"
}

variable = "out_warning_threshold" {
  description "warning Threshold for scale_out"
}

variable = "out_critical_threshold" {
  description "Critical Threshold for scale_out"
}

variable = "out_renotify_interval" {
  description "OK Threshold for scale_out"
}

# Scaling in #
variable = "in_ok_threshold" {
  description "OK Threshold for scale_out"
}

variable = "in_warning_threshold" {
  description "warning Threshold for scale_out"
}

variable = "in_critical_threshold" {
  description "Critical Threshold for scale_out"
}

variable = "in_renotify_interval" {
  description "OK Threshold for scale_out"
}
