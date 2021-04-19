#!/bin/bash
set -euo pipefail

export KUBE_NAMESPACE=${ENVIRONMENT}
export KUBE_SERVER="https://kube-api-notprod.notprod.acp.homeoffice.gov.uk"
export KUBE_TOKEN=${KUBE_TOKEN}
export VERSION=${VERSION}
export NAME="hocs-message-generator"
# ise epoch time to create a unique job
export DEPLOYED_AT=`date +'%s'`

export RUN_CONFIG_NUM_MESSAGES=${RUN_CONFIG_NUM_MESSAGES=1}
export RUN_CONFIG_COMPLAINT_TYPE=${RUN_CONFIG_COMPLAINT_TYPE=""}

export KUBE_CERTIFICATE_AUTHORITY="https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/acp-notprod.crt"

cd kd || exit 1

kd --timeout 3m \
    -f message-generator-job.yaml 

kubectl wait job/${NAME}-${DEPLOYED_AT} --for=condition=complete

kd --timeout 3m \
    --delete \
    -f message-generator-job.yaml 

