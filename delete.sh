#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

DIRECTORY=/tmp/deletelogs
if [ ! -d "$DIRECTORY" ]; then
  echo "Error: Directory $DIRECTORY does not exist."
else
  echo "Directory $DIRECTORY exists."
fi
