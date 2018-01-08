#! /bin/bash
set -e

useradd -m puma
cd /home/puma
git clone https://github.com/Otus-DevOps-2017-11/reddit.git
cd reddit && bundle install
chown -R puma:puma /home/puma/reddit
cp /tmp/puma.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable puma.service
