#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

disk_usage=$(df -hT|grep "xfs")
threshold=90
message=""
while IFS= read -r line; do
    usage=$(echo $line | awk -F ' '{print $6}"|cut -d % -f1)
    partition=$(echo $line | awk '{print $1F}')
    if [ "$usage" -gt threshold ]; then
    message+="High Disk Usage on $partition: $usage \n"
    fi
done <<< $disk_usage
echo -e "High disk utilization:$message"