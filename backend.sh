log_file=/tmp/expense.log
MySQL_PASSWORD=$1

Head () {
  echo -e "\e[35m$1\e[0m"
}


Head "disable default version of nodeJS"
dnf module disable nodejs -y &>>$log_file
echo $?

Head "enable nodeJS18 version"
dnf module enable nodejs:18 -y &>>$log_file
echo $?

Head "install nodeJS"
dnf install nodejs -y &>>$log_file
echo $?

Head "adding application user"
useradd expense &>>$log_file
echo $?

Head "configure backend service"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
echo $?

Head "remove existing app content"
rm -rf /app &>>$log_file
echo $?

Head "create application directory"
mkdir /app &>>$log_file
echo $?

Head "Download application content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app
echo $?

Head "Extracting application content"
unzip /tmp/backend.zip &>>$log_file
echo $?

Head "Installing application dependencies"
npm install &>>$log_file
echo $?

Head "reloading systemd and start backend service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
echo $?

Head "Install MySQL client"
dnf install mysql -y &>>$log_file
echo $?

Head "Load schema"
mysql -h mysql-dev.aquireawsdevops.online -uroot -p${MySQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
echo $?

#We can use $1 instead of ${MySQL_PASSWORD}

#password: ExpenseApp@1