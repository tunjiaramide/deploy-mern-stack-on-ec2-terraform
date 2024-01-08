#!/bin/bash

# Install NGINX, MERN (Mysql, ReactJs and Nodejs) on Ubuntu 22.04

# Update
sudo apt update -y


# Install mysql and start
sudo apt install mysql-server -y
sudo systemctl start mysql.service
sudo systemctl enable mysql.service


# Install nodeJs
curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install nodejs -y


# Install nginx and start
sudo apt install nginx -y
sudo systemctl start nginx.service
sudo systemctl enable nginx.service

# Install pm2
sudo npm install -g pm2

# Install git
sudo add-apt-repository ppa:git-core/ppa
sudo apt install git -y


# Configure application

# Copy application from github
cd /var/www/
sudo git clone https://github.com/tunjiaramide/movie-app.git

# Set up database schema
sudo mysql < movie-app/schema.sql

# install client app
cd movie-app/client
sudo npm install 
sudo npm run build 
pm2 start dist/


# install backend app
cd ../
cd backend
sudo npm install 
pm2 start server.js


# configure nginx

sudo rm /etc/nginx/sites-available/default
cat <<EOF | sudo tee /etc/nginx/sites-available/default >/dev/null
server {
    listen 80 default_server;
    server_name _;

    #react app frontend
    location / {
        root /var/www/movie-app/client/dist;
        try_files \$uri /index.html;
    }

    #backend app 
    location /api/ {
        proxy_pass http://\$host:5000/;
    }
}
EOF

sudo nginx -t
sudo systemctl reload nginx.service



