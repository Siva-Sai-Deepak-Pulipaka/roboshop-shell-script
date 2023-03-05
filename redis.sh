source common.sh
echo -e "\e[33mInstalling repo\e[0m"
status_check $?

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>{log_file}
status_check $?
dnf module enable redis:remi-6.2 -y &>>{log_file}       
status_check $?
yum install redis -y &>>{log_file}
status_check $?
sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf &>>{log_file}
status_check $?
systemctl enable redis &>>{log_file}
systemctl start redis &>>{log_file}