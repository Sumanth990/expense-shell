MySQL_PASSWORD=$1

component=frontend
source common.sh

Head "Install Nginx"
dnf install nginx -y &>>$log_file
Stat $?

Head "Copy expense configuration"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
Stat $?

app_prereq "/usr/share/nginx/html"

Head "Start Nginx services"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
Stat $?
