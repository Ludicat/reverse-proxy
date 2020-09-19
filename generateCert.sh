#!/bin/bash

openssl genrsa -des3 -out server.key 2048
openssl rsa -in server.key -out server.key.insecure
rm server.key
mv server.key.insecure server.key
openssl req -new -key server.key -out server.csr -config server.cnf

openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt

mv server.key certs/
mv server.csr certs/
mv server.crt certs/

# Use on Ubuntu to add new certificate to trust list
#sudo cp certs/server.crt /usr/local/share/ca-certificates/
#sudo update-ca-certificates
