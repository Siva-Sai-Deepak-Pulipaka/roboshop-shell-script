code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file} #we want to get updated log for every command so we are using this strategy that we are removing log file earlier.
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