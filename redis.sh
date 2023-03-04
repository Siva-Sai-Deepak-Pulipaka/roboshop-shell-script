echo -e "\e[33mInstalling repo\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

dnf module enable redis:remi-6.2 -y

yum install redis -y 
sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf
systemctl enable redis 
systemctl start redis 