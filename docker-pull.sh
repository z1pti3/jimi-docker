#!/bin/sh

docker stop jimi_core
docker stop jimi_web
docker stop jimi_db

docker rm jimi_core
docker rm jimi_web
docker rm jimi_db

docker rmi z1pti3/jimi_core:amd64
docker rmi z1pti3/jimi_web:amd64
docker rmi mongo:latest

docker pull mongo:latest
docker pull z1pti3/jimi_core:amd64
docker pull z1pti3/jimi_web:amd64

docker network create jimi_network
docker run -d -v /home/ubuntu/jimi/db:/data/db --net jimi_network --name jimi_db mongo:latest
docker run -it -d -v /home/ubuntu/jimi/data:/home/jimi/jimi/data -v /home/ubuntu/jimi/plugins:/home/jimi/jimi/plugins --net jimi_network --name jimi_core z1pti3/jimi_core:amd64
docker run -it -d -p 5002:5002 -v /home/ubuntu/jimi/data:/home/jimi/jimi/data -v /home/ubuntu/jimi/plugins:/home/jimi/jimi/plugins --net jimi_network --name jimi_web z1pti3/jimi_web:amd64

docker logs jimi_core