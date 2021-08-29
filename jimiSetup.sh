#!/bin/bash

dir=$(pwd)

mkdir jimi
cd jimi

mkdir data
mkdir plugins
mkdir db

git clone https://github.com/z1pti3/jimiPlugin-humio.git plugins/humio
git clone https://github.com/z1pti3/jimiPlugin-script.git plugins/script
git clone https://github.com/z1pti3/jimiPlugin-event.git plugins/event
git clone https://github.com/z1pti3/jimiPlugin-occurrence.git plugins/occurrence
git clone https://github.com/z1pti3/jimiPlugin-testFire.git plugins/testFire
git clone https://github.com/z1pti3/jimiPlugin-email.git plugins/email
git clone https://github.com/z1pti3/jimiPlugin-remote.git plugins/remote
git clone https://github.com/z1pti3/jimiPlugin-api.git plugins/api

cd data
mkdir temp
mkdir storage
mkdir log
wget https://raw.githubusercontent.com/z1pti3/jimi-docker/master/data/settings.json
openssl genrsa -out private.pem 2048
openssl rsa -in private.pem -outform PEM -pubout -out sessionPub.pem 
openssl rsa -in private.pem -out sessionPriv.pem -outform PEM 
rm private.pem

openssl req -newkey rsa:2048 -nodes -keyout web.key -x509 -days 365 -out web.cert -subj "/C=GB/ST=London/L=London/O=jimi/OU=jimi/CN=jimiproject"

cd ..
adduser --no-create-home --disabled-password --gecos "" jimi
chown jimi:jimi -R data/
chown jimi:jimi -R plugins/

cd $dir

docker network create jimi_network
docker run -d -v $dir/jimi/db:/data/db --net jimi_network --name jimi_db mongo:latest
docker run -it -u `id -u jimi`:`id -g jimi` -d -v $dir/jimi/data:/home/jimi/jimi/data -v $dir/jimi/plugins:/home/jimi/jimi/plugins --net jimi_network --name jimi_core z1pti3/jimi_core:amd64
docker run -it -u `id -u jimi`:`id -g jimi` -d -p 4443:4443 -v $dir/jimi/data:/home/jimi/jimi/data -v $dir/jimi/plugins:/home/jimi/jimi/plugins --net jimi_network --name jimi_web z1pti3/jimi_web:amd64

docker logs jimi_core
