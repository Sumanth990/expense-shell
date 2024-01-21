log_file=/tmp/expense.log

Head () {
  echo -e "\e[35m$1\e[0m"
}

#create a function
app_prereq () {

  Head "remove existing app content"
  rm -rf $1 &>>$log_file
  if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit 1
fi

  Head "create application directory"
  mkdir $1 &>>$log_file
  if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit 1
fi

  Head "Download application content"
  curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit 1
fi

  cd $1

  Head "Extracting application content"
  unzip /tmp/${component}.zip &>>$log_file
  if [ $? -eq 0 ]; then
echo Success
else
echo Failure
exit 1
fi
}
