#!/usr/bin/env bash

if [[ "$#" -ne 1 ]]; then
    echo "usage: $0 [user]"
    exit 1
fi

echo "Creating user key"
openssl genrsa -des3 -out $1.key 4096
echo "Creating user certificate signing request"
openssl req -new -key $1.key -out $1.csr
echo "Signing the csr to a certificate valid for 365 days"
openssl x509 -req -days 365 -in $1.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out $1.crt
echo "Creating pfx package"
openssl pkcs12 -export -out $1.pfx -inkey $1.key -in $1.crt -certfile ca.crt
