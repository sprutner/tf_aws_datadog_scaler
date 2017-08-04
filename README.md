# Datadog Autoscaler #

## Pre-requisites ##
* Autoscaling group resource name, either outputted from a module, or present in the root (see `asg_name` for example)
* Datadog provider set up already with API and APP keys

### Usage ###
Simply paste the following block into your terraform config, and change the values as you desire.

# Example main.tf: #

```hcl
#Load up API Gateway Lambda integration for Nomad Continuous Deployment
module "nomad_node_memory" {
  source                  = "github.com/sprutner/tf_aws_datadog_autoscaler"
  name                    = "Memory"
  environment             = "${var.environment}"
  asg_name                = "${module.nomad_nodes.asg_name}"
  scale_out_monitor_name  = "Nomad memory is low"
  scale_in_monitor_name   = "Nomad memory is high"
  out_ok_threshold        = 1200000001
  out_warning_threshold   = 1200000000
  out_critical_threshold  = 1000000000
  out_renotify_interval   = 5
  in_ok_threshold         = 1499999999
  in_warning_threshold    = 1700000000
  in_critical_threshold   = 2000000000
  in_renotify_interval    = 7
}
```
