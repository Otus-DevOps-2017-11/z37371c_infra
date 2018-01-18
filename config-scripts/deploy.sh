#! /bin/bash

git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install
puma -d
echo "Puma status:"
if ps aux | grep -q "[p]uma"; 
then ps aux | grep "[p]uma" | tr -s " " | cut -d " " -f 11-
else echo "puma is not running..."
fi
