sudo amazon-linux-extras install -y epel
sudo yum install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod