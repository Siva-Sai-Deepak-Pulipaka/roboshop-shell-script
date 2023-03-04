source common.sh

print_head "installing nginx"
yum install nginx -y &>>${log_file}

#&>> means appending output and also errors to a single file named log_file

print_head "removing old content in nginx html"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "downloading frontend component"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>${log_file}

#cp config-files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf
#The above line is the actual command to access the config file. But after we run the above commands based on document we will be in /usr/share/nginx/html so config-files directory is not presented here. so we are declaring variable at the start. Because script always run from top to bottom.

print_head "copying nginx configuration file "
cp ${code_dir}/config-files/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
print_head "enabling nginx"
systemctl enable nginx &>>${log_file}

#we have implemented restart because nginx gets updated everytime we make changes in our components

print_head "restarting nginx"
systemctl restart nginx &>>${log_file}
