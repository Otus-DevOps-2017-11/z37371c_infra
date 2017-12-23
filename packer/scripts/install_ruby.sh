#! /bin/bash

set -e

#ruby
apt update
apt install -y ruby-full ruby-bundler build-essential
echo "Ruby version:"
ruby -v
echo "Bundler version:"
bundler -v

