#!/bin/bash

set -euo pipefail

CA_SRC="/vagrant/certs/rootCA.crt"

# 1) Host OS trust store
if [ -d /usr/local/share/ca-certificates ]; then               # Debian/Ubuntu
  cp "${CA_SRC}" /usr/local/share/ca-certificates/
  update-ca-certificates                                    # :contentReference[oaicite:0]{index=0}
else                                                         # RHEL/Rocky/CentOS
  cp "${CA_SRC}" /etc/pki/ca-trust/source/anchors/
  update-ca-trust extract                                   # :contentReference[oaicite:1]{index=1}
fi

# 2) CRI-O trust for private registries
install -d /etc/containers/certs.d/registry.k8s.lab
cp "${CA_SRC}" /etc/containers/certs.d/registry.k8s.lab/ca.crt  # :contentReference[oaicite:2]{index=2}

echo "Root CA installed on $(hostname)"
