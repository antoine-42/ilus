#!/usr/bin/env bash

echo "Recreating the certificate authority certificate, valid for 10 years."
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
