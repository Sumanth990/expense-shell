echo disable default version of nodeJS
dnf module disable nodejs -y

echo enable nodeJS18 version
dnf module enable nodejs:18 -y

echo install nodeJS
dnf install nodejs -y

echo adding application user
useradd expense

echo configure backend service
cp backend.service /etc/systemd/system/backend.service

echo remove existing app content
rm -rf /app

echo create application directory
mkdir /app

echo Download application content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip
cd /app

echo Extracting application content
unzip /tmp/backend.zip

echo Installing application dependencies
npm install

echo reloading systemd and start backend service
systemctl daemon-reload
systemctl enable backend
systemctl restart backend

echo Install MySQL client
dnf install mysql -y

echo Load schema
mysql -h mysql-dev.aquireawsdevops.online -uroot -pExpenseApp@1 < /app/schema/backend.sql
