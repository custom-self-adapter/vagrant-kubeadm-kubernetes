#!/bin/bash
#
# Generates rootCA.crt and rootCA.key
# This will be injected as a trusted CA in all nodes by install_ca.sh
# The ingress-nginx certificate will be signed by this CA
# The host must trust this CA too

set -euo pipefail

CA_DIR="/vagrant/certs"

if [ -f $CA_DIR/rootCA.key ]
then
    echo "Root CA already exists, skipping"
    exit 0
fi

mkdir -p $CA_DIR && cd $CA_DIR
openssl genrsa -out rootCA.key 4096
openssl req  -x509 -days 3650 -key rootCA.key \
  -addext "keyUsage=critical,digitalSignature,keyCertSign" \
  -subj "/CN=k8s.lab Root CA" -sha256 -out rootCA.crt 
