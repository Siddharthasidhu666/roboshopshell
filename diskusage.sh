#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

disk_usage=$(df -hT|grep "xfs")
threshold=1
message=[]
while IFS= read -r line; do
    usage=$($line| awk -F ' '{print $6}"|cut -d % -f1)
    if [ "$usage" -gt 90 ]; then
    message+=disk_usage
    fi
done <<< $disk_usage

echo "$message"