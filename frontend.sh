source common.sh
dir=${pwd}
print_head "installing nginx"
yum install nginx -y 
print_head "removing old content in nginx html"
rm -rf /usr/share/nginx/html/* 
print_head "downloading frontend component"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip
#cp config-files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
#The above line is the actual command to access the config file. But after we run the above commands based on document we will be in /usr/share/nginx/html so config-files directory is not presented here. so we are declaring variable at the start. Because script always run from top to bottom.
print_head "copying nginx configuration file "
cp ${dir}/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
print_head "enabling nginx"
systemctl enable nginx 
#we have implemented restart because nginx gets updated everytime we make changes in our components
print_head "restarting nginx"
systemctl restart nginx 
