source common.sh
component = catalogue
echo -e "${colour} Configuring NodeJS Repos ${Nocolour}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

echo -e "${colour} Install NodeJS ${Nocolour}
yum install nodejs -y &>>${log_file}

echo -e "${colour} Add Application User ${Nocolour}
useradd roboshop &>>${log_file}

echo -e "${colour} Create Application Directory ${Nocolour}
rm -rf $${app_path} &>>${log_file}
mkdir ${app_path} &>>${log_file}

echo -e "${colour}Download Application Content ${Nocolour}
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
cd ${app_path} 

echo -e "${colour} Extract Application Content ${Nocolour}
unzip /tmp/${component}.zip &>>${log_file}
cd ${app_path}

echo -e "${colour} Install NodeJS Dependencies ${Nocolour}
npm install &>>${log_file}

echo -e "${colour} Setup systemd service  ${Nocolour}
cp /root/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}


echo -e "${colour} Restart ${component} Service ${Nocolour}
systemctl daemon-reload &>>${log_file}
systemctl enable ${component}  &>>${log_file}
systemctl restart ${component} &>>${log_file}


echo -e ${colour} Copy MongoDB Repo file ${${Nocolour}}
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log_file}


echo -e ${colour} Install MongoDB Client${${Nocolour}}
yum install mongodb-org-shell -y &>>${log_file}


echo -e ${colour} Load Schema ${${Nocolour}}
mongo --host mongodb-dev.harshadevops.shop <${app_path}/schema/${component}.js &>>${log_file}