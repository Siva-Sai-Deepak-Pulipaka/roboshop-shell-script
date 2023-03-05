source common.sh
if [ -z "${rabbitmq_user_pass}" ]; then
echo "Enter rabbitmq password along with script"
exit 1
fi
component=payment
PYTHON