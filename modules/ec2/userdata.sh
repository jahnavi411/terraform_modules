sudo yum update -y
sudo yum install git -y
cd /home/ec2-user
git clone https://github.com/jahnavi411/django_terraform_repo.git
cd django_terraform_repo/
pip3 install django
sudo pip3 install django
sudo pip3 install psycopg2-binary
sudo pip3 install pillow
sudo dnf search postgresql
sudo dnf install -y postgresql15 postgresql15-server
#sudo /usr/bin/postgresql-setup --initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
python manage.py migrate
python manage.py runserver 0.0.0.0:8000