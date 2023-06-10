color="\e[32m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"  


app_presetup () {
   
echo -e "${color} Add Application User ${nocolor}"
id roboshop &>>$log_file 
if [$? -eq 1 ]; then 
 useradd roboshop &>>$log_file
fi
if [ $? -eq 0 ]; then 
  echo SUCCESS
else
  echo FAILURE
fi   


echo -e "${color} Create Application Directory ${nocolor}"
rm -rf ${app_path} &>>$log_file
mkdir ${app_path} &>>$log_file
if [ $? -eq 0 ]; then 
  echo SUCCESS
else
  echo FAILURE
fi   

echo -e "${color}Download Application Content ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
if [ $? -eq 0 ]; then 
  echo SUCCESS
else
  echo FAILURE
fi   

echo -e "${color} Extract Application Content ${nocolor}"
cd ${app_path}
unzip /tmp/$component.zip &>>$log_file
if [ $? -eq 0 ]; then 
  echo SUCCESS
else
  echo FAILURE
fi   
 
 }

 systemd_setup() {

 echo -e "${color} Setup systemd service  ${nocolor}"
 cp /root/roboshop-shell/$component.service /etc/systemd/system/$component.service &>>$log_file
 if [ $? -eq 0 ]; then 
  echo SUCCESS
 else
  echo FAILURE
 fi
 

 echo -e "${color} Restart $component Service ${nocolor}"
 systemctl daemon-reload &>>$log_file
 systemctl enable $component  &>>$log_file
 systemctl restart $component &>>$log_file
 if [ $? -eq 0 ]; then 
  echo SUCCESS
 else
  echo FAILURE  
 fi 

 }

nodejs () { 

 echo -e "${color} Configuring NodeJS Repos ${nocolor}"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

 echo -e "${color} Install NodeJS ${nocolor}"
 yum install nodejs -y &>>$log_file


 app_presetup

 

 echo -e "${color} Install NodeJS Dependencies ${nocolor}"
 npm install &>>$log_file


 systemd_setup

 
}

  mongo_schema_setup () {
    
echo -e "${color} Copy MongoDB Repo file ${nocolor}"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>$log_file


echo -e "${color} Install MongoDB Client ${nocolor}"
yum install mongodb-org-shell -y &>>$log_file


echo -e "${color} Load Schema ${nocolor}"
mongo --host mongodb-dev.harshadevops.shop <${app_path}/schema/$component.js &>>$log_file
}

mysql_schema_setup() {


echo -e "${color} Install Mysql Client ${nocolor}"
yum install mysql -y &>>$log_file

echo -e "${color} Load schema${nocolor}"
mysql -h mysql-dev.harshadevops.shop -uroot -pRoboShop@1 < ${app_path}/schema/$component.sql &>>$log_file

}

maven ()
{
  echo -e "${color} Install Maven ${nocolor}"
yum install maven -y &>>$log_file

app_presetup

echo -e "${color} Download Dependencies ${nocolor}"
mvn clean package &>>$log_file
mv target/$component-1.0.jar $component.jar &>>$log_file


mysql_schema_setup



systemd_setup 
}

python() {

echo -e "${color} Install Python ${nocolor}"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
if [ $? -eq 0 ];  then 
  echo SUCCESS
 else
  echo FAILURE
fi   



app_presetup


echo -e "${color} Download application Dependencies ${nocolor}"
cd /app 
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log
if [ $? -eq 0 ]; then 
  echo SUCCESS
 else
  echo FAILURE
fi   

systemd_setup

}