variable "name" {
  description = "Name of this datadog scaler"
}

variable "environment" {
  description = "Environment this is running in"
}

variable "asg_name" {
  description = "Name of the Autoscaling Group to apply this to. "
}

variable "scale_out_monitor_name" {
  description = "What you want to name the scale out monitor name E.G. Nomad cluster memory low"
}

variable "scale_in_monitor_name" {
  description = "What you want to name the scale out monitor name E.G. Nomad cluster memory high"
}

## Thresholds ##

# Scaling out #
variable "out_ok_threshold" {
  description = "OK Threshold for scale_out"
}

variable "out_warning_threshold" {
  description = "warning Threshold for scale_out"
}

variable "out_critical_threshold" {
  description = "Critical Threshold for scale_out"
}

variable "out_renotify_interval" {
  description = "OK Threshold for scale_out"
}

variable "out_avg_by" {
  description = "What to average by, E.G. min, max, avg"
  default     = "max"
}

# Scaling in #
variable "in_ok_threshold" {
  description = "OK Threshold for scale_out"
}

variable "in_warning_threshold" {
  description = "warning Threshold for scale_out"
}

variable "in_critical_threshold" {
  description = "Critical Threshold for scale_out"
}

variable "in_renotify_interval" {
  description = "OK Threshold for scale_out"
}

variable "in_avg_by" {
  description = "What to average by, E.G. min, max, avg"
  default     = "avg"
}

variable "query_metric" {
  description = "The metric you are querying, EG, system.mem.free"
}

## Extra mmonitor array
variable "in_extra_name" {
  type = "list"
}

variable "in_extra_ok_threshold" {
  description = "OK Threshold for scale_out"
  type        = "list"
}

variable "in_extra_warning_threshold" {
  description = "warning Threshold for scale_out"
  type        = "list"
}

variable "in_extra_critical_threshold" {
  description = "Critical Threshold for scale_out"
  type        = "list"
}

variable "in_extra_renotify_interval" {
  description = "OK Threshold for scale_out"
  type        = "list"
}

variable "in_extra_avg_by" {
  description = "What to average by, E.G. min, max, avg"
  type        = "list"
  default     = "avg"
}

variable "in_extra_query_metric" {
  description = "The metric you are querying, EG, system.mem.free"
  type        = "list"
}
