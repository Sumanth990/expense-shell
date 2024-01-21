log_file=/tmp/expense.log

Head () {
  echo -e "\e[35m$1\e[0m"
}

#create a function
app_prereq () {
  dir=$1

  Head "remove existing app content"
  rm -rf $1 &>>$log_file
  echo $?

  Head "create application directory"
  mkdir $1 &>>$log_file
  echo $?

  Head "Download application content"
  curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  echo $?

  cd $1

  Head "Extracting application content"
  unzip /tmp/${component}.zip &>>$log_file
  echo $?
}
