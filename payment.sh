source common.sh
if [ -z "${rabbitmq_app_pass}" ]; then
echo "Enter rabbitmq password along with script"
exit 1
fi
component=payment
PYTHON