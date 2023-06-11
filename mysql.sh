echo -e "\e[33m Disable Mysql Default version\e[0m"
yum module disable mysql -y  &>>/tmp/roboshop.log

echo -e "\e[33m Copy Mysql repo file \e[0m"
cp /home/centos/roboshop-shell/mysql.repo  /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[33m Install  Mysql Community server \e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log



echo -e "\e[33m Start Mysql service \e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld  &>>/tmp/roboshop.log

echo -e "\e[33m Setup Mysql password \e[0m"
mysql_secure_installation --set-root-pass $1 &>>/tmp/roboshop.log
