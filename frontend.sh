echo -e "\e[33mInstalling Nginx Server\e[0m"
yum install nginx -y >/tmp/roboshop.log


"\e[33mRemoving Old App content\e[0m"
rm -rf /usr/share/nginx/html/* >/tmp/roboshop.log

"\e[33mDownloading frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip >/tmp/roboshop.log

"\e[33mExtract frontend  content\e[0m"
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip >/tmp/roboshop.log


# we need to copy config file

"\e[33mStarting Nginx Server\e[0m"
systemctl enable nginx >/tmp/roboshop.log
systemctl start nginx >/tmp/roboshop.log