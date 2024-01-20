MySQL_PASSWORD=$1

source common.sh

Head "Install Nginx"
dnf install nginx -y &>>$log_file
echo $?

Head "Copy expense configuration"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log_file
echo $?

Head "Remove Default content"
rm -rf /usr/share/nginx/html/* &>>$log_file
echo $?

Head "Download frontend content"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
cd /usr/share/nginx/html
echo $?

Head "Extract frontend content"
unzip /tmp/frontend.zip &>>$log_file
echo $?

Head "Start Nginx services"
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
echo $?
