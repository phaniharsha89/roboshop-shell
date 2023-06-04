echo -e "\e[33m Install Erlang Repos\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[33m Install Rebbitmq Repos\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[33m Install Rabbit MQ Server\e[0m"
yum install rabbitmq-server -y

echo -e "\e[33m Start Rabbit MQ Service \e[0m"
systemctl enable rabbitmq-server 
systemctl start rabbitmq-server 

echo -e "\e[33m Add Rabbit MQ Application user\e[0m"
rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"