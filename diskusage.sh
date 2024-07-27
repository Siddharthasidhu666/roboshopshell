#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

disk_usage=$(df -hT|grep "xfs")
threshold=1
message=[]
while IFS= read -r line; do
  output=$($line| awk -F ' '{print $6}"|cut -d % -f1)
  message+=output
done <<< $diskusgae

echo "$message"