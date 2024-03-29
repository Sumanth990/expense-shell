log_file=/tmp/expense.log

Head () {
  echo -e "\e[35m$1\e[0m"
}

#create a function
app_prereq () {

  Head "remove existing app content"
  rm -rf $1 &>>$log_file
 Stat $?

  Head "create application directory"
  mkdir $1 &>>$log_file
  Stat $?

  Head "Download application content"
  curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
Stat $?

  cd $1

  Head "Extracting application content"
  unzip /tmp/${component}.zip &>>$log_file
}

Stat () {
if [ "$1" -eq 0 ]; then #variable use double quotes
echo Success
else
echo Failure
exit 1
fi
}