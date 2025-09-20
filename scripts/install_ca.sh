#!/bin/bash

set -euo pipefail

CA_SRC="/vagrant/certs/rootCA.crt"

if [ ! -f $CA_SRC ]; then
  echo "Root CA not found on $(hostname)"
  exit
fi

# 1) Host OS trust store
if [ -d /usr/local/share/ca-certificates ]; then
  cp "${CA_SRC}" /usr/local/share/ca-certificates/
  update-ca-certificates
else
  cp "${CA_SRC}" /etc/pki/ca-trust/source/anchors/
  update-ca-trust extract
fi

# 2) CRI-O trust for private registries
install -d /etc/containers/certs.d/registry.k8s.lab
cp "${CA_SRC}" /etc/containers/certs.d/registry.k8s.lab/ca.crt

echo "Root CA installed on $(hostname)"
