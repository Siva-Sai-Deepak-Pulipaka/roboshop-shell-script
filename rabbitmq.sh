source common.sh
rabbitmq_user_pass=$1
if [ -z "${rabbitmq_user_pass}" ]; then
echo "Enter rabbitmq password along with script"
exit 1
fi
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash 
yum install erlang -y
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
yum install rabbitmq-server -y 
systemctl enable rabbitmq-server 
systemctl start rabbitmq-server 
rabbitmqctl add_user roboshop ${rabbitmq_user_pass}
rabbitmqctl set_user_tags roboshop administrator
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"