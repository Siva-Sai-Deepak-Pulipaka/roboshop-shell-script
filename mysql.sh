source common.sh

MYSQL_ENTER_PASSWORD_PROMPT #here enter password is same for both mysql and shipping. so we created a function and calling.

print_head "disabling default mysql "
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "coping/installing mysql repo"
cp config-files/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "installing particular mysql "
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "enabling and starting mysql server"
systemctl enable mysqld &>>${log_file}
systemctl start mysqld &>>${log_file}
status_check $?

print_head "checking password for mysql"
echo show databases | mysql -uroot -p${mysql_root_pass} &>>${log_file}
if [ $? -ne 0 ]; then
mysql_secure_installation --set-root-pass ${mysql_root_pass} &>>${log_file}
fi
status_check $?


