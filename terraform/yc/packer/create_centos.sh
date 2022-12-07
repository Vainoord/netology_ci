#!/bin/bash
# set a password for the server user
echo "netology:$( cat centos_pass.txt | openssl enc -aes-256-cbc -md sha512 -a -d -pass pass:'D0nT-Tr4s1' )" | sudo chpasswd
sleep 1
# push an ssh key into home folder
echo "$( cat centos_key.txt )" | openssl enc -aes-256-cbc -md sha512 -a -d -pass pass:'D0nT-Tr4s1' | sudo tee -a /home/netology/.ssh/authorized_keys 
sleep 1
exit 0