#!/bin/bash
# password for user netology in servers
PASS=""
# ssh public key for servers connections
SSH=""

# encryption for centos7
echo $PASS | openssl enc -aes-256-cbc -md sha512 -a -pass pass:'D0nT-Tr4s1' > centos_pass.txt
echo $SSH | openssl enc -aes-256-cbc -md sha512 -a -pass pass:'D0nT-Tr4s1' > centos_key.txt
# encryption for centos7
echo $PASS | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'D0nT-Tr4s1' > debian_pass.txt
echo $SSH | openssl enc -aes-256-cbc -md sha512 -a -pbkdf2 -iter 100000 -salt -pass pass:'D0nT-Tr4s1' > debian_key.txt
echo 'Files succesfully generated'
exit 0
