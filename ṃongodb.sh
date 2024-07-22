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

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>> $LOGFILE
VALIDATE $? "Enabling monodb"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Starting monodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf 
VALIDATE $? "Remote access to MongoDB" &>> $LOGFILE

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "restarting monodb"

