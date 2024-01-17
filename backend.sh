echo -e "\e[36m disable default version of nodeJS\e[0m"
dnf module disable nodejs -y

echo -e "\e[36m enable nodeJS18 version\e[0m"
dnf module enable nodejs:18 -y

echo -e "\e[36m install nodeJS\e[0m"
dnf install nodejs -y

echo -e "\e[36m adding application user\e[0m"
useradd expense

echo -e "\e[36m configure backend service\e[0m"
cp backend.service /etc/systemd/system/backend.service

echo -e "\e[36m remove existing app content\e[0m"
rm -rf /app

echo -e "\e[36m create application directory\e[0m"
mkdir /app

echo -e "\e[36m Download application content\e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app

echo -e "\e[36m Extracting application content\e[0m"
unzip /tmp/backend.zip

echo -e "\e[36m Installing application dependencies\e[0m"
npm install

echo -e "\e[36m reloading systemd and start backend service\e[0m"
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

echo -e "\e[36m Install MySQL client\e[0m"
dnf install mysql -y

echo -e "\e[36m Load schema\e[0m"
mysql -h mysql-dev.aquireawsdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
