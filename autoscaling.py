from __future__ import print_function
import json
import boto3
import re
client = boto3.client('autoscaling')
def lambda_handler(event, context):
    messages = event['Records'][0]['Sns']['Message']
    message_lines = messages.split('\n')
    first_line = re.sub(' +', ' ' , message_lines[ 0 ])
    number_of_services = first_line.split(' ')
    number = int( number_of_services[1] ) + int( 1 )
    message_array = []
    for i in range(1, number):
        strtemp = re.sub(' +', ' ' ,message_lines[i])
        message_array = message_array + strtemp.split(' ')
    number = number - 1
    temp = 0
    for j in range(0, number):
        temp = int( temp ) + 1
        asg = message_array[ j + temp ]
        temp = int( temp ) + 1
        scaling_policy = message_array[ j + temp ]
        temp = int( temp ) + 1
        metric_value = int(message_array[ j + temp ])
        response = client.execute_policy(
            AutoScalingGroupName=asg,
            PolicyName=scaling_policy,
            BreachThreshold=50,
            MetricValue=metric_value
   )
    return "ok"
