#!/bin/sh

docker pull mongo:latest
docker pull z1pti3/jimi_core:amd64
docker pull z1pti3/jimi_web:amd64

docker run -d -v /home/ubuntu/jimi/db:/jimi/db --name jimi_db mongo:latest
docker run -d -v /home/ubuntu/jimi/data:/jimi/data --name jimi_core z1pti3/jimi_core:amd64
docker run -d -p 5002:5002 -v /home/ubuntu/jimi/data:/jimi/data --name jimi_web z1pti3/jimi_web:amd64


docker logs jimi_core