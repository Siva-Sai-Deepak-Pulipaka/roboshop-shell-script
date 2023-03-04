code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file} #we want to get updated log for every command so we are using this strategy that we are removing log file earlier.
print_head()
{
    echo -e "\e[32m$1\e[0m"
}
print_head "running the script to get nodejs repo file"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
yum install nodejs -y &>>${log_file}

print_head "adding roboshop-user"
useradd roboshop &>>${log_file}

echo -e "\e[34mCreating app directory\e[0m"  # just testing the echo command 
mkdir /app &>>${log_file}
rm -rf /app/* #we are removing the contents to sattisfy code standard (re-run should never fail)

print_head "downloading the catalogue folder"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app &>>${log_file}

print_head "extracted files"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "installing node package manager"
npm install &>>${log_file}

print_head "creating catalogue service file"
cp ${code_dir}/config-files/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head "changes updated, enabled and started catalogue server"
systemctl daemon-reload &>>${log_file}
systemctl enable catalogue &>>${log_file}
systemctl start catalogue &>>${log_file}

print_head "installing mongodb repo"
cp ${code_dir}/config-files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "installing mongo client and connected to host"
yum install mongodb-org-shell -y 
mongo --host mongodb.easydevops.online </app/schema/catalogue.js 