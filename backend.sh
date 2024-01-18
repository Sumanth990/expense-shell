echo -e "\e[36m disable default version of nodeJS\e[0m"
dnf module disable nodejs -y &>> /tmp/expense.log

echo -e "\e[36m enable nodeJS18 version\e[0m"
dnf module enable nodejs:18 -y &>> /tmp/expense.log

echo -e "\e[36m install nodeJS\e[0m"
dnf install nodejs -y &>> /tmp/expense.log

echo -e "\e[36m adding application user\e[0m"
useradd expense &>> /tmp/expense.log

echo -e "\e[36m configure backend service\e[0m"
cp backend.service /etc/systemd/system/backend.service &>> /tmp/expense.log

echo -e "\e[36m remove existing app content\e[0m"
rm -rf /app &>> /tmp/expense.log

echo -e "\e[36m create application directory\e[0m"
mkdir /app &>> /tmp/expense.log

echo -e "\e[36m Download application content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>> /tmp/expense.log
cd /app

echo -e "\e[36m Extracting application content\e[0m"
unzip /tmp/backend.zip &>> /tmp/expense.log

echo -e "\e[36m Installing application dependencies\e[0m"
npm install &>> /tmp/expense.log

echo -e "\e[36m reloading systemd and start backend service\e[0m"
systemctl daemon-reload &>> /tmp/expense.log
systemctl enable backend &>> /tmp/expense.log
systemctl restart backend &>> /tmp/expense.log

echo -e "\e[36m Install MySQL client\e[0m"
dnf install mysql -y &>> /tmp/expense.log

echo -e "\e[36m Load schema\e[0m"
mysql -h mysql-dev.aquireawsdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>> /tmp/expense.log



