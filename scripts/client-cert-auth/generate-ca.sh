#!/usr/bin/env bash

echo "Creating the certificate authority"
openssl genrsa -des3 -out ca.key 4096
echo "Creating the certificate authority certificate"
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
