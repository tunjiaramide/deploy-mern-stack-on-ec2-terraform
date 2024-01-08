## Deploy MERN stack to AWS EC2 using terraform

In this project, we will deploy a movie application built using Mysql, React, and Nodejs onto AWS EC2.

We will be deploying this MERN project - https://github.com/tunjiaramide/movie-app

Prerequisites
It is assumed you have terraform installed on your system
You must have set up AWS credentials on your system

Steps
Clone the repo and cd into the folder
run terraform init
run terraform apply --auto-approve
Congrats you will get a public IP to view your website.

Notes
After terraform finishes, AWS takes time to provision the server, so be patient until checks get to 2/2 from the console to view website.
