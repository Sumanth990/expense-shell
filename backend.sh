log_file=/tmp/expense.log
MySQL_PASSWORD=$1

echo -e "\e[36m disable default version of nodeJS\e[0m"
dnf module disable nodejs -y &>>$log_file

echo -e "\e[36m enable nodeJS18 version\e[0m"
dnf module enable nodejs:18 -y &>>$log_file

echo -e "\e[36m install nodeJS\e[0m"
dnf install nodejs -y &>>$log_file

echo -e "\e[36m adding application user\e[0m"
useradd expense &>>$log_file

echo -e "\e[36m configure backend service\e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file

echo -e "\e[36m remove existing app content\e[0m"
rm -rf /app &>>$log_file

echo -e "\e[36m create application directory\e[0m"
mkdir /app &>>$log_file

echo -e "\e[36m Download application content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
cd /app

echo -e "\e[36m Extracting application content\e[0m"
unzip /tmp/backend.zip &>>$log_file

echo -e "\e[36m Installing application dependencies\e[0m"
npm install &>>$log_file

echo -e "\e[36m reloading systemd and start backend service\e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl restart backend &>>$log_file

echo -e "\e[36m Install MySQL client\e[0m"
dnf install mysql -y &>>$log_file

echo -e "\e[36m Load schema\e[0m"
mysql -h mysql-dev.aquireawsdevops.online -uroot -p${MySQL_PASSWORD} < /app/schema/backend.sql &>>$log_file

#We can use $1 instead of ${MySQL_PASSWORD}

#password: ExpenseApp@1