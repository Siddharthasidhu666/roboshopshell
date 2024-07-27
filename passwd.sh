#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

FILE=/tmp/passwd
if [ ! -f "$FILE" ]; then
  echo "Error: Directory $FILE does not exist."
fi

while IFS=':' read -r username password UID GID full_name home_directory shell; do
  echo "username=$username"
  echo "full_name=$full_name"
  echo "shell=$shell"
  
done < $FILE