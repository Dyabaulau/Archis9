sudo yum update -y

sudo touch /etc/yum.repos.d/mongodb-org-6.0.repo

sudo echo "[mongodb-org-6.0]" >> /etc/yum.repos.d/mongodb-org-6.0.repo
sudo echo "name=MongoDB Repository" >> /etc/yum.repos.d/mongodb-org-6.0.repo
sudo echo "baseurl=https://repo.mongodb.org/yum/amazon/2/mongodb-org/6.0/x86_64/" >> /etc/yum.repos.d/mongodb-org-6.0.repo
sudo echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-org-6.0.repo
sudo echo "enabled=1" >> /etc/yum.repos.d/mongodb-org-6.0.repo
sudo echo "gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc" >> /etc/yum.repos.d/mongodb-org-6.0.repo

sudo yum install -y mongodb-org

sudo mongod --bind_ip 0.0.0.0 -f /etc/mongod.conf

echo 'db.createCollection("ta_db")' | mongosh ta_db