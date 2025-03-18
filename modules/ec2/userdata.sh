#!/bin/bash

# Update system packages
sudo yum update -y
sudo yum install -y git python3 python3-pip python3-venv

# Navigate to ec2-user home directory
cd /home/ec2-user/

# Clone the GitHub repository
git clone https://github.com/deparkes/simple-django-app.git
cd simple-django-app

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Django and dependencies
pip install --upgrade pip
pip install django 
pip install psycopg2-binary -y
sudo yum install postgresql-libs -y
sudo yum install libpq-dev -y
pip install pillow

# Install PostgreSQL
#sudo amazon-linux-extras enable postgresql15
#sudo yum install -y postgresql postgresql-server postgresql-devel postgresql-contrib postgresql-docs

# Initialize and start PostgreSQL
#sudo /usr/bin/postgresql-setup --initdb
#sudo systemctl enable postgresql
#sudo systemctl start postgresql

# Set up Django migrations
python manage.py migrate

# Run Django server in the background
nohup python manage.py runserver 0.0.0.0:8000
