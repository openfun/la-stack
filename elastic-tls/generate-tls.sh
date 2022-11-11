#!/bin/bash 
set -e

check_docker() {
  if ! command -v docker &> /dev/null
  then
    echo "Docker could not be found"
    echo "Docker is required to run this script, please install"
    exit
  fi
}

check_config() {
  if [ ! -f ./certutil-input.yaml ]; then
    echo "certutil-input.yaml not found"
    echo "You must create certutil-input.yaml before running this script."
    exit
  fi
}

help() {
   # Display Help
   echo "Script for generating Elastic TLS fils."
   echo
   echo "Usage: $0 [-v <string>] [-t <single|cluster>] [-p <string>]"
   echo
   echo "options:"
   echo 
   echo "-v     Set Elaticsearch version, exp 7.17.0."
   echo "-t     single or cluster type."
   echo "-p     Password for CA and certificates."
   echo "-h     Print Help."
   echo
}

usage() { help 1>&2; exit 1; }

clean() {

  if [ -f ./my-ca.p12 ]; then
    echo "Clean up old CA / Certificates"
    rm -rf ./my-ca.p12 ./my-keystore.p12 ./keystore ./hsperfdata_root
  fi
  
}

while getopts ":v:t:p:h" o; do
    case "${o}" in
        v)
            ELASTIC_VERSION=${OPTARG}
            ;;
        t)
            TYPE=${OPTARG}
            ;;
        p)
            PASS=${OPTARG}
            ;;
        h)
            help
            exit 0
            ;;
        *)
            echo "${o}"
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${ELASTIC_VERSION}" ] || [ -z "${TYPE}" ] || [ -z "${PASS}" ]; then
    echo
    echo "Missing required parameters"
    echo "--------------------------------"
    echo
    usage
fi

check_docker
check_config
clean

if [ $TYPE == "single" ] || [ $TYPE == "cluster" ]; then
    docker run --rm -t \
        --mount type=bind,source="$(pwd)",target=/tmp \
        docker.elastic.co/elasticsearch/elasticsearch:$ELASTIC_VERSION \
        bash -c "bash /tmp/cert-tools.sh $TYPE $PASS"
else
    echo
    echo "You must set single or cluster type."
    echo "--------------------------------"
    echo
    usage
fi
