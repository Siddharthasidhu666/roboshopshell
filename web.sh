#!/bin/bash
ID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"   

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
    exit 1 
    else
        echo -e "$2 ... $G SUCCESS $N"
fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 
else
    echo "You are root user"
fi

dnf install nginx -y
VALIDATE $? "insatlling nginx"

systemctl enable nginx
VALIDATE $? "enabling nginx"

systemctl start nginx
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/*
VALIDATE $? "removing files"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip
VALIDATE $? "Download web file"

cd /usr/share/nginx/html

unzip -o /tmp/web.zip &>> $LOGFILE
VALIDATE $? "unzipping files"

cp /root/roboshopshell/roboshop.conf /etc/nginx/default.d/
VALIDATE $? "copying roboshop conf"

sed -i "7s/localhost/172.31.89.193/" /etc/nginx/default.d/roboshop.conf
VALIDATE $? "configured"


systemctl restart nginx 
VALIDATE $? "restarting nginx"