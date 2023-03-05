source common.sh
user(){

print_head "installing node repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "installing nodejs"
yum install nodejs -y &>>${log_file}

print_head "creating roboshop user"
useradd roboshop &>>${log_file}

print_head "creating app directory"
mkdir /app &>>${log_file}

print_head "removing contents if any"
rm -rf /app/*

print_head "Downloading zip file and switched to app directory"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log_file} 
cd /app &>>${log_file}

print_head "extract zip file"
unzip /tmp/user.zip &>>${log_file}

print_head "installing node package manager"
npm install &>>${log_file}

print_head "copying service file"
cp ${code_dir}/config-files/user.service /etc/systemd/system/user.service &>>${log_file}
systemctl daemon-reload &>>${log_file}
systemctl enable user 
systemctl start user

print_head "installing mongodb repo"
cp ${code_dir}/config-files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "installing mongo client and connected to host"
yum install mongodb-org-shell -y &>>${log_file}
mongo --host mongodb.easydevops.online </app/schema/user.js &>>${log_file}

}
user