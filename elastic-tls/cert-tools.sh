#!/bin/bash 
set -e

echo " 1) Generating CA"
elasticsearch-certutil ca --silent --out /tmp/my-ca.p12 --pass $2

echo " 2) Generating certificates"
case $1 in
  cluster)
    elasticsearch-certutil cert --silent --multiple --ca /tmp/my-ca.p12 --ca-pass $2 --out /tmp/my-keystore.p12 --pass $2 --in /tmp/certutil-input.yaml
    ;;
  single)
    elasticsearch-certutil cert --silent --ca /tmp/my-ca.p12 --ca-pass $2 --out /tmp/my-keystore.p12 --pass $2 --in /tmp/certutil-input.yaml
    ;;
    *)
    echo "Usage: $0 {cluster|single} PASSWORD" 
    exit 1
esac

echo " 3) Extract certificates"
unzip /tmp/my-keystore.p12 -d /tmp/keystore

echo "Done!"