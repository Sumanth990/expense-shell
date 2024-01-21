log_file=/tmp/expense.log
MySQL_PASSWORD=$1

component=backend
source common.sh

Head "disable default version of nodeJS"
dnf module disable nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

Head "enable nodeJS18 version"
dnf module enable nodejs:18 -y &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

Head "install nodeJS"
dnf install nodejs -y &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

Head "adding application user"
useradd expense &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi


Head "configure backend service"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

#we are keeping "/app" here because conf file will fail due to change of directory path.

app_prereq "/app"

Head "Installing application dependencies"
npm install &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

Head "reloading systemd and start backend service"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

Head "Install MySQL client"
dnf install mysql -y &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

Head "Load schema"
mysql -h mysql-dev.aquireawsdevops.online -uroot -p${MySQL_PASSWORD} < /app/schema/backend.sql &>>$log_file
if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit
fi

#We can use $1 instead of ${MySQL_PASSWORD}

#password: ExpenseApp@1