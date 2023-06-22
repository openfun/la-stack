#!/usr/bin/env bash

set -eo pipefail

declare ELASTIC_VERSION="${ELASTIC_VERSION:-7.17.0}"
declare TYPE="${TYPE:-cluster}"
declare DOCKER_RUN_ELASTIC


check_docker() {
  if ! command -v docker &> /dev/null
  then
    echo "Docker could not be found"
    echo "Docker is required to run this script, please install it first."
    exit
  fi
}


check_config() {
  if [ ! -f ./certutil-input.yaml ]; then
    echo "certutil-input.yaml not found"
    echo "You must create the certutil-input.yaml file before running this script."
    exit
  fi
}


help() {
   # Display Help
   echo "Script for generating Elasticsearch TLS files."
   echo
   echo "Usage: $0 [-V <string>] [-t <single|cluster>]"
   echo
   echo "options:"
   echo
   echo "-V     Set Elaticsearch version, exp 7.17.0."
   echo "-t     single or cluster type."
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


generate_ca() {
  eval "${DOCKER_RUN_ELASTIC} bash -c '\
    elasticsearch-certutil \
      ca \
      --silent \
      --out /tmp/my-ca.p12 \
      --pass \"\" \
'"
}


generate_certs() {
  local certutil_base_cmd="elasticsearch-certutil \
      cert \
      --silent \
      --ca /tmp/my-ca.p12 \
      --ca-pass \"\" \
      --out /tmp/my-keystore.p12 \
      --pass \"\" \
      --in /tmp/certutil-input.yaml \
"
  if [ "$TYPE" == "single" ]; then
      eval "${DOCKER_RUN_ELASTIC} bash -c '${certutil_base_cmd} --multiple'"
  elif [ "$TYPE" == "cluster" ]; then
      eval "${DOCKER_RUN_ELASTIC} bash -c '${certutil_base_cmd}'"
  else
      echo
      echo "The type must be single or cluster."
      echo "--------------------------------"
      echo
      usage
  fi
}


while getopts ":V:t:h" o; do
    case "${o}" in
        V)
            ELASTIC_VERSION=${OPTARG}
            ;;
        t)
            TYPE=${OPTARG}
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


if [ -z "${ELASTIC_VERSION}" ] || [ -z "${TYPE}" ]; then
    echo
    echo "Missing required parameters"
    echo "--------------------------------"
    echo
    usage
fi


# The ELASTIC_VERSION variable should be set now
DOCKER_RUN_ELASTIC="docker run --rm -t \
    --user $(id -u):$(id -g) \
    --mount type=bind,source=\"${PWD}\",target=/tmp \
    docker.elastic.co/elasticsearch/elasticsearch:\"${ELASTIC_VERSION}\" \
"


check_docker
check_config
clean
echo " 1) Generating CA"
generate_ca
echo " 2) Generating certificates"
generate_certs
echo " 3) Extract certificates"
unzip my-keystore.p12 -d keystore
echo "Done!"
