sudo yum update -y
sudo yum install git -y
git clone https://github.com/LondheShubham153/django-tutorial.git
cd django-tutorial/
pip3 install django
sudo pip3 install django
sudo pip3 install psycopg2-binary
sudo pip3 install pillow
sudo dnf search postgresql
sudo dnf install -y postgresql15 postgresql15-server
sudo /usr/bin/postgresql-setup --initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
