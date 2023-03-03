code_dir=$(pwd)
log_file=/tmp/roboshop.log #creating a log file. the log gets updated by using redirectors.
rm -f ${1og_file}
print_head() {
   echo -е "\e[36m$1\e[0m"
}
