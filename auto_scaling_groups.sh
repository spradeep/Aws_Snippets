#!/bin/bash

asg="$1"

if [[ -z "$asg" ]]; then
   aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].[AutoScalingGroupName, length(Instances)]' --output table
read -p "AutoScale Groupname [press enter to quit] : " asg
    if [[ -z "$asg" ]]; then
        exit
    fi
fi


for instance_id in $(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names $asg \
    --query 'AutoScalingGroups[0].Instances[*].InstanceId' \
    --output text); do

    public_ip=$(aws ec2 describe-instances \
        --instance-ids "$instance_id" \
        --query 'Reservations[*].Instances[*].PublicIpAddress' \
        --output text)

    echo "Instance ID: $instance_id, Public IP: $public_ip"

done
