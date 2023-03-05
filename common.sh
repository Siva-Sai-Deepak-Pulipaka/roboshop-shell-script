code_dir=$(pwd)
log_file=/tmp/roboshop.log

rm -f ${log_file}                               #we want to get updated log for every command so we are using this strategy that we are removing log file earlier.
print_head()
{
    echo -e "\e[32m$1\e[0m"
}
status_check()
{
    if [ $1 -eq 0 ]; then
        echo success
    else
        echo -e "\e[31mfailure\e[0m"
    fi
}
ROBOSHOP_APP_SETUP()
{
    print_head "creating roboshop user if not exists"
    id roboshop &>>${log_file}                    #id command will return either 0 or 1. if exists then 0, if not exists 1
    if [ $? -ne 0 ]; then                         # $? returns status of the previously executed command either 0 or 1 so in our case the 'id roboshop' will return 1 because roboshop not exists when we run first time. This is just an enhancement. No need to worry on mentioning the condition. Even if you don't specify condition, re-run script still works
        useradd roboshop &>>${log_file}
    fi
    status_check $?

    print_head "creating app directory "
    if [ ! -d /app ]; then                         #Here if you run this line status shows failure but its not a failure. re-run leads to condition failure as we mentioned in 'status_check' function above. so to avoid it displaying failure we specified condition 
        mkdir /app &>>${log_file}
    fi       
    status_check $?

    print_head "removing contents if any"
    rm -rf /app/*
    status_check $?

    print_head "Downloading zip file and switched to app directory"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file} 
    cd /app &>>${log_file}
    status_check $?

    print_head "extract zip file"
    unzip /tmp/${component}.zip &>>${log_file}
    status_check $?
}

NODEJS()
{
    print_head "installing node repo"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
    status_check $?

    print_head "installing nodejs"
    yum install nodejs -y &>>${log_file}
    status_check $?

    #here creating roboshop user and app directory downloading components and extracting into app is same for some components. so we are creating another function and call it wherever needed.
    ROBOSHOP_APP_SETUP
    
    print_head "installing node package manager"
    npm install &>>${log_file}
    status_check $?

    print_head "copying ${component} service file"
    cp ${code_dir}/config-files/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
    status_check $?

    #here for both mysql and shipping systemctl daemon-reload, enable, and restart are same. so we are creating a function named SYSTEMD_SETUP and calling it.    
    SCHEMA_SETUP
}

SYSTEMD_SETUP()
{
    print_head "reloading ${component} service "
    systemctl daemon-reload &>>${log_file}
    status_check $?

    print_head "enabling and starting ${component} service"
    systemctl enable ${component} &>>${log_file}
    systemctl start ${component} &>>${log_file}
    status_check $?
}

SCHEMA_SETUP()
{
    if [ "${schema_type}" == "mongo" ]; then
        print_head "installing mongodb repo"
        cp ${code_dir}/config-files/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
        status_check $?

        print_head "installing mongo client and connected to mongo host to load schema"
        yum install mongodb-org-shell -y &>>${log_file}
        status_check $?
        mongo --host mongodb.easydevops.online </app/schema/${component}.js &>>${log_file}
        status_check $?
    elif [ "${schema_type}" == "mysql" ]; then
        print_head "install mysql client"
        yum install mysql -y 

        print_head "loading mysql shipping schema"
        mysql -h mysql.easydevops.online -uroot -p${mysql_root_pass} < /app/schema/shipping.sql 
    fi
}

JAVA()
{
    yum install maven -y

    ROBOSHOP_APP_SETUP #user add and creating app directory, downloading zip and extarct into app directory is quite common. so we are linking wherever required
    
    print_head "downloading packages and dependencies"
    mvn clean package 
    mv target/${component}-1.0.jar ${component}.jar
    cp ${code_dir}/config-files/${component}.service /etc/systemd/system/${component}.service
    
    #here for both mysql and shipping systemctl daemon-reload, enable, and restart are same. so we are creating a function named SYSTEMD_SETUP and calling it.
    SCHEMA_SETUP
    #Here According to documentation, SYSTEMD_SETUP(systemd enable restart) is to present before the SCHEMA_SETUP but we are placing after schema just to restart after all changes. 
    SYSTEMD_SETUP 
}

MYSQL_ENTER_PASSWORD_PROMPT()
{
    mysql_root_pass=$1
if [ -z "${mysql_root_pass}" ]; then          # -z will check if the variable is empty. if it is empty returns 0 or else returns 1
    echo "Enter mysql password"
    exit 1 
fi
}