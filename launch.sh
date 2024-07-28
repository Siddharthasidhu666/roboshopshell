#!/bin/bash
launch=(web app redis rabbitmq)
type=t2.micro

for item in ${launch[@]}
do
    aws ec2 run-instances \
    --image-id ami-0b4f379183e5706b9 \
    --instance-type $type \
    --security-group-ids sg-0ea30ddacc888b57c \
    --tag-specifications ResourceType=instance,Tags=[{Key=Name,Value=$item}] \

done