source common.sh
echo -e "\e[33mInstalling repo\e[0m"
status_check $?

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y 
status_check $?
dnf module enable redis:remi-6.2 -y        
status_check $?
yum install redis -y 
status_check $?
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf /etc/redis/redis.conf 
status_check $?
systemctl enable redis 
systemctl start redis 