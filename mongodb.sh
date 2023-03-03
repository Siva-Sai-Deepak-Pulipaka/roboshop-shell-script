source common.sh
print_head "copying repo file"
cp config-files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
print_head "installing mongodb"
yum install mongodb-org -y &>>${log_file}
print_head "enabling and starting mongod server"
systemctl enable mongod &>>${log_file}
systemctl start mongod &>>${log_file}
#we need to update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf so we are using sed command
print_head "updating listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e "s/127.0.0.1/0.0.0.0/g" &>>${log_file}
print_head "restarting mongodb server"
systemctl restart mongod &>>${log_file}