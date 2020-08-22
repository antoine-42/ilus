#!/usr/bin/env bash

echo "Creating the certificate authority."
openssl genrsa -des3 -out ca.key 4096
echo "Creating the certificate authority certificate, valid for 10 years."
echo extendedKeyUsage = serverAuth >> extfile.cnf
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt -extfile extfile.cnf
