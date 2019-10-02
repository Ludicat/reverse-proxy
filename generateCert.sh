#!/bin/bash

openssl genrsa -des3 -out server.key 2048
openssl rsa -in server.key -out server.key.insecure
rm server.key
mv server.key.insecure server.key
openssl req -new -key server.key -out server.csr -config server.cnf

openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

mv server.key certs/
mv server.cer certs/
mv server.crt certs/
