#! /bin/bash

#check for root
IAM=$(whoami)
if [ ${IAM} != "root" ]; then
    echo "You must be root to use this script"
    exit 1
fi

#install ruby
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
echo "Ruby version:"
ruby -v
echo "Bundler version:"
bundler -v

#install mongo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
sudo bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'

sudo apt update
sudo apt install -y mongodb-org

sudo systemctl start mongod
sudo systemctl enable mongod
echo "MongoDB service status:"
sudo systemctl status mongod

#deploy reddit-app

git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install
puma -d
echo "Puma status:"

#if ps aux | grep -q "[p]uma"; then
#    ps aux | grep "[p]uma" | tr -s " " | cut -d " " -f 11-

if pgrep -f puma; then 
    pgrep -f puma -a
else 
    echo "puma is not running..."
fi
