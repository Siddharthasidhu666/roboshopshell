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

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app  &>> $LOGFILE
VALIDATE $? "created directory app"

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip  &>> $LOGFILE
VALIDATE $? "installed user"

cd /app
VALIDATE $? "changed directory"


unzip -o /tmp/user.zip  &>> $LOGFILE
VALIDATE $? "unzippied"

npm install   &>> $LOGFILE
VALIDATE $? "installed depedndenices"

cp /root/roboshopshell/user.service /etc/systemd/system/  &>> $LOGFILE
VALIDATE $? "copied successfully"

sed -i "6s/<REDIS-SERVER-IP>/172.31.89.134/" /etc/systemd/system/user.service  &>> $LOGFILE
VALIDATE $? "replaced" 

sed -i "7s/<MONGODB-SERVER-IP-ADDRESS>/172.31.93.32/" /etc/systemd/system/user.service  &>> $LOGFILE
VALIDATE $? "replaced" 



systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "restarting deamon"

systemctl enable user  &>> $LOGFILE
VALIDATE $? "enabling user"

systemctl start user  &>> $LOGFILE
VALIDATE $? "starting user"

cp /root/roboshopshell/mongo.repo /etc/yum.repos.d/ &>> $LOGFILE
VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org-shell -y  &>> $LOGFILE
VALIDATE $? "installed shell"


mongo --host 172.31.93.32 </app/schema/user.js  &>> $LOGFILE







