#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

disk_usage=$(df -hT|grep "xfs")
echo $disk_usage