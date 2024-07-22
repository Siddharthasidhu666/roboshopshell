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

dnf install maven -y
VALIDATE $? "installing maven"

id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir p /app
VALIDATE $? " create dir"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

cd /app
VALIDATE $? "moved app"

unzip -o /tmp/shipping.zip
VALIDATE $? "unzipped"

mvn clean package
VALIDATE $? "cleaned"

mv target/shipping-1.0.jar shipping.jar
VALIDATE $? "renamed"

cp shipping.service /etc/systemd/system/
sed -i "6s/<CART-SERVER-IPADDRESS>/172.31.90.102/" /etc/systemd/system/shipping.service
sed -i "6s/<MYSQL-SERVER-IPADDRESS>/172.31.90.89/" /etc/systemd/system/shipping.service


systemctl daemon-reload
VALIDATE $? "reloaad"

systemctl enable shipping 
VALIDATE $? "enable"

systemctl start shipping
VALIDATE $? "start"

dnf install mysql -y
VALIDATE $? "install sql"

mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql
VALIDATE $? "success" 

systemctl restart shipping
VALIDATE $? "restart"