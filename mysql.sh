source common.sh
mysql_root_pass=$1
if [ -z "${mysql_root_pass}" ]; then          # -z will check if the variable is empty. if it is empty returns 0 or else returns 1
    echo "Enter mysql password"
    exit 1 
fi
 #here enter password is same for both mysql and shipping. so we experimentally created a function and calling.it didn't work. so removed

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


