${MySQL_PASSWORD}=$1

dnf module disable mysql -y
cp mysql.repo /etc/yum.repos.d/mysql.repo
dnf install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass ${1}

#${MySQL_PASSWORD}
# password: ExpenseApp@1