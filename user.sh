code_dir=$(pwd)
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum install nodejs -y
useradd roboshop
mkdir /app
rm -rf /app/*
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip 
cd /app 
unzip /tmp/user.zip
npm install 
cp ${code_dir}/config-files/user.service /etc/systemd/system/user.service
systemctl daemon-reload
systemctl enable user 
systemctl start user