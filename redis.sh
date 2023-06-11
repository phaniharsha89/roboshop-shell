source common.sh



echo -e "${color} Install Redis Repos \e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
stat_chek $?

echo -e "${color} Enable Redis 6 Version \e[0m"
yum module enable redis:remi-6.2 -y &>>$log_file
stat_chek $?

echo -e "${color} Install Redis  \e[0m"
yum install redis -y &>>$log_file
stat_chek $?

echo -e "${color} Update Redis Listen address \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/'  /etc/redis.conf  /etc/redis/redis.conf &>>$log_file
stat_chek $?

echo -e "${color} start Redis service\e[0m"
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file
stat_chek $?