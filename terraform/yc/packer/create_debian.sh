#!/bin/bash
# set a password for the server user
echo "netology:$( cat debian_pass.txt | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:'D0nT-Tr4s1' )" | sudo chpasswd
sleep 1
# push an ssh key into home folder
echo "$( cat debian_key.txt )" | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:'D0nT-Tr4s1' | sudo tee -a /home/netology/.ssh/authorized_keys 
sleep 1
exit 0