source common.sh
mysql_root_pass=$1
if [ -z "${mysql_root_pass}" ]; then          # -z will check if the variable is empty. if it is empty returns 0 or else returns 1
    echo "Enter mysql password"
    exit 1 
fi #here enter password is same for both mysql and shipping. so we experimentally created a function and calling. it didn't work. so removed
component=shipping
schema_type="mysql"
JAVA