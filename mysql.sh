source common.sh

echo -e "${color} Disable Mysql Default version ${nocolor}"
yum module disable mysql -y  &>>$log_file
stat_chek $?

echo -e "${color} Copy Mysql repo file ${nocolor}"
cp /home/centos/roboshop-shell/mysql.repo  /etc/yum.repos.d/mysql.repo &>>$log_file
stat_chek $?

echo -e "${color} Install  Mysql Community server ${nocolor}"
yum install mysql-community-server -y &>>$log_file
stat_chek $?



echo -e "${color} Start Mysql service ${nocolor}"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld  &>>$log_file
stat_chek $?

echo -e "${color} Setup Mysql password ${nocolor}"
mysql_secure_installation --set-root-pass $1 &>>$log_file
stat_chek $?
