# Datadog Autoscaler #

*Version 0.1*

First working POC.

Enhancements to come:
* Use of real metrics in scaling policies
* More control over step-scaling when calling module

## Pre-requisites ##
* Autoscaling group resource name, either outputted from a module, or present in the root (see `asg_name` for example)
* Datadog provider set up already with API and APP keys

### Usage ###
Simply paste the following block into your terraform config, and change the values as you desire.

# Example main.tf: #

```hcl
#Load up API Gateway Lambda integration for Nomad Continuous Deployment
module "nomad_node_memory" {
  source                  = "github.com/sprutner/tf_aws_datadog_scaler"
  name                    = "Memory"
  environment             = "${var.environment}"
  asg_name                = "${module.nomad_client.asg_name}"
  scale_out_monitor_name  = "Nomad worker memory is low"
  scale_in_monitor_name   = "Nomad worker memory is high"
  out_ok_threshold        = 1000000002
  out_warning_threshold   = 1000000001
  out_critical_threshold  = 1000000000
  out_renotify_interval   = 5
  in_ok_threshold         = 1799999999
  in_warning_threshold    = 1800000000
  in_critical_threshold   = 2000000000
  in_renotify_interval    = 7
  query_metric            = "system.mem.free"

}
```

### Shout Outs and Thanks ###

I forked the Python script from https://dev.bleacherreport.com/autoscaling-based-on-datadog-sns-and-lambda-in-aws-11e07897f248 and adapted this guide for creation of this module
