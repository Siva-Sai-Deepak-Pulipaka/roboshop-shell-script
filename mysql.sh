source common.sh
mysql_root_pass=$1
if [ -z "${mysql_root_pass}" ]; then          # -z will check if the variable is empty. if it is empty returns 0 or else returns 1
    echo "Enter mysql password"
    exit 1 
fi
print_head "disabling default mysql "
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "coping/installing mysql repo"
cp config-files/mysql.repo /etc/yum.repos.d/mysql.repo
status_check $?

print_head "installing particular mysql "
yum install mysql-community-server -y
status_check $?

print_head "enabling and starting mysql server"
systemctl enable mysqld
systemctl start mysqld
status_check $?

print_head "set password for mysql"
mysql_secure_installation --set-root-pass ${mysql_root_pass}
status_check $?

print_head "testing credentials"
mysql -uroot -pRoboShop@1
status_check $?