source common.sh 
rabbitmq_app_pass=$1
if [ -z "${rabbitmq_app_pass}" ]; then
    echo "Enter rabbitmq password along with script"
    exit 1
fi
component=dispatch
GOLANG
