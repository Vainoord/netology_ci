#!/bin/bash
# This script create docker containers from centos7, ubuntu and fedora images

# pull the images
echo "--- initialising containter installation ---"
docker pull centos:centos7
echo "--- centos 7 image uploaded ---"
sleep 2
docker pull pycontribs/fedora
echo "--- fedora image uploaded --- "
sleep 2


# install python libraries in ubuntu image. It takes usually 25 seconds
docker build -t ubuntu2204 docker/
echo "--- ubuntu image created ---"
sleep 2

# create containers
docker create -it --name ubuntu ubuntu2204:latest
echo "--- ubuntu container created ---"
sleep 2
docker create -it --name centos7 centos:centos7
echo "--- centos7 container created ---"
sleep 2
docker create -it --name fedora pycontribs/fedora:latest
echo "--- fedora container created ---"
sleep 2

# run containers
docker start ubuntu
docker start centos7
docker start fedora
echo "--- containers are running ---"
sleep 2

# launch playbook
ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
sleep 2

# stopping docker containers
echo "--- stopping containers ---"
docker stop ubuntu
docker stop centos7
docker stop fedora
echo "--- containers stopped ---"
sleep 2
