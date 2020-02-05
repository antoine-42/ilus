#!/usr/bin/env bash

# Create CA Certificate.
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
