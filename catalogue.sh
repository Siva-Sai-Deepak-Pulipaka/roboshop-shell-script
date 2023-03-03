log_file=/tmp/roboshop.log
rm -f ${log_file} #we want to get updated log for every command so we are using this strategy that we are removing log file earlier.
print_head()
{
    echo -e "\e[32m$1\e[0m"
}
print_head "running the script to get nodejs repo file"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y

print_head "adding roboshop-user"
useradd roboshop

echo -e "\e[m34Creating app directory\e[0m" # just testing the echo command 
mkdir /app 
rm -rf /app/* #we are removing the contents to sattisfy code standard (re-run should never fail)

print_head "downloading the catalogue folder"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 
cd /app 

print_head "extracted files"
unzip /tmp/catalogue.zip

print_head "installing node package manager"
npm install 

print_head "creating catalogue service file"
cp config-files/catalogue.service /etc/systemd/system/catalogue.service

print_head "changes updated, enabled and started catalogue server"
systemctl daemon-reload
systemctl enable catalogue 
systemctl start catalogue

print_head "installing mongodb repo"
cp config-files/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "installing mongo client and connected to host"
yum install mongodb-org-shell -y
mongo --host mongodb.easydevops.online </app/schema/catalogue.js