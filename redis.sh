source common.sh
echo -e "\e[33mInstalling repo\e[0m"
status_check $?
print_head "installing repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}
status_check $?

print_head "enabling redis 6.2"
dnf module enable redis:remi-6.2 -y &>>${log_file}       
status_check $?

print_head "installing redis 6.2"
yum install redis -y &>>${log_file}
status_check $?

print_head "updating listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}
status_check $?
print_head "enabling and restarting redis"
systemctl enable redis 
systemctl restart redis 