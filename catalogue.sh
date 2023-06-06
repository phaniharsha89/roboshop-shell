source common.sh
component = {component} 
echo -e {colour} Configuring NodeJS Repos {No colour}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>{log_file}

echo -e {colour} Install NodeJS {No colour}
yum install nodejs -y &>>{log_file}

echo -e {colour} Add Application User {No colour}
useradd roboshop &>>{log_file}

echo -e {colour} Create Application Directory {No colour}
rm -rf {app_path} &>>{log_file}
mkdir {app_path} &>>{log_file}

echo -e {colour}Download Application Content {No colour}
curl -o /tmp/{component}.zip https://roboshop-artifacts.s3.amazonaws.com/{component}.zip &>>{log_file}
cd {app_path} 

echo -e {colour} Extract Application Content {No colour}
unzip /tmp/{component}.zip &>>{log_file}
cd {app_path}

echo -e {colour} Install NodeJS Dependencies {No colour}
npm install &>>{log_file}

echo -e {colour} Setup systemd service  {No colour}
cp /root/roboshop-shell/{component}.service /etc/systemd/system/{component}.service &>>{log_file}


echo -e {colour} Restart {component} Service {No colour}
systemctl daemon-reload &>>{log_file}
systemctl enable {component}  &>>{log_file}
systemctl restart {component} &>>{log_file}


echo -e {colour} Copy MongoDB Repo file {No colour}
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>{log_file}


echo -e {colour} Install MongoDB Client{No colour}
yum install mongodb-org-shell -y &>>{log_file}


echo -e {colour} Load Schema {No colour}
mongo --host mongodb-dev.harshadevops.shop <{app_path}/schema/{component}.js &>>{log_file}