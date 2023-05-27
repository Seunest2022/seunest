#!/bin/bash

# Deploy Pre-Requisites
echo "Installing FirewallD..."
sudo yum install -y firewalld
sudo service firewalld start
sudo systemctl enable firewalld

# Deploy and Configure Database
echo "Installing MariaDB..."
sudo yum install -y mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb

echo "Configuring firewall for Database..."
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --reload

echo "Configuring Database..."
sudo mysql -e "CREATE DATABASE ecomdb;"
sudo mysql -e "CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Load Product Inventory Information to database
echo "Creating db-load-script.sql..."
sudo cat > db-load-script.sql << EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment, Name varchar(255) default NULL, Price varchar(255) default NULL, ImageUrl varchar(255) default NULL, PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name, Price, ImageUrl) VALUES ("Laptop", "100", "c-1.png"), ("Drone", "200", "c-2.png"), ("VR", "300", "c-3.png"), ("Tablet", "50", "c-5.png"), ("Watch", "90", "c-6.png"), ("Phone Covers", "20", "c-7.png"), ("Phone", "80", "c-8.png"), ("Laptop", "150", "c-4.png");
EOF

echo "Running sql script..."
sudo mysql < db-load-script.sql

# Deploy and Configure Web
echo "Installing required packages..."
sudo yum install -y httpd php php-mysqli
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --reload

echo "Configuring httpd..."
sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf

echo "Starting httpd..."
sudo systemctl start httpd
sudo systemctl enable httpd

echo "Downloading code..."
sudo yum install -y git
sudo git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/

echo "Updating index.php..."
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

echo "Testing..."
curl http://localhost
