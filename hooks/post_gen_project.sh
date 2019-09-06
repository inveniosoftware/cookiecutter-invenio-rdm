#!/usr/bin/env sh

echo "-------------------------------------------------------------------------------"
echo
echo "Generating SSL certificate and private key for testing...."

openssl req -x509 -newkey rsa:4096 -nodes -out docker/nginx/test.crt -keyout docker/nginx/test.key -days 365 -subj "/C=CH/ST=./L=./O=./OU=./CN=localhost/emailAddress=."

echo "-------------------------------------------------------------------------------"

