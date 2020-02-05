#!/usr/bin/env bash

if [[ "$#" -ne 2 ]]; then
    echo "usage: $0 [user] [increment]"
    exit 1
fi

echo "Resigning the csr to a certificate, valid for 10 years."
openssl x509 -req -days 3650 -in $1.csr -CA ca.crt -CAkey ca.key -set_serial $2 -out $1.crt
echo "Creating pfx package."
openssl pkcs12 -export -out $1.pfx -inkey $1.key -in $1.crt -certfile ca.crt
