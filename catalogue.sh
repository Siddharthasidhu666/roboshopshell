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

dnf module disable nodejs -y  &>> $LOGFILE
VALIDATE $? "disabled nodejs"

dnf module enable nodejs:18 -y  &>> $LOGFILE
VALIDATE $? " enabled nodejs 18"

dnf install nodejs -y  &>> $LOGFILE
VALIDATE $? " installing nodejs"

useradd roboshop  &>> $LOGFILE
VALIDATE $? "useradded"

mkdir -p /app  &>> $LOGFILE
VALIDATE $? "created directory app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $LOGFILE
VALIDATE $? "installed catalogue"

cd /app
VALIDATE $? "changed directory"


unzip -o /tmp/catalogue.zip  &>> $LOGFILE
VALIDATE $? "unzippied"

npm install   &>> $LOGFILE
VALIDATE $? "installed depedndenices"

cp /root/roboshopshell/catlogue.service /etc/systemd/system/catalogue.service  &>> $LOGFILE
VALIDATE $? "copied successfully"

sed -i "7s/<MONGODB-SERVER-IPADDRESS>/172.31.93.32/" /etc/systemd/system/catalogue.service  &>> $LOGFILE
VALIDATE $? "replaced" 



systemctl daemon-reload  &>> $LOGFILE
VALIDATE $? "restarting deamon"

systemctl enable catalogue  &>> $LOGFILE
VALIDATE $? "enabling catalogue"

systemctl start catalogue  &>> $LOGFILE
VALIDATE $? "starting catalogue"

cp /root/roboshopshell/mongo.repo /etc/yum.repos.d/ &>> $LOGFILE
VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org-shell -y  &>> $LOGFILE
VALIDATE $? "installed shell"


mongo --host 172.31.93.32 </app/schema/catalogue.js  &>> $LOGFILE







