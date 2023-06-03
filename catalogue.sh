echo -e "\e[33mConfiguring NodeJS Repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[33mInstall NodeJS \e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[33mAdd Application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[33m Create Application Directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33mDownload Application Content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app 

echo -e "\e[33mExtract Application Content \e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[33mInstall NodeJS Dependencies \e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[33m Setup systemd service  \e[0m"
cp /root/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log


echo -e "\e[33m Restart Catalogue Service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue  &>>/tmp/roboshop.log
systemctl start catalogue &>>/tmp/roboshop.log


echo -e "\e[33mCopy MongoDB Repo file \e[0m"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log


echo -e "\e[33m Install MongoDB Client\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log


echo -e "\e[33m Load Schema \e[0m"
mongo --host mongodb-dev.harshadevops.shop </app/schema/catalogue.js &>>/tmp/roboshop.log