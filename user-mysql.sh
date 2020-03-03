#!/bin/sh

set -xe

export AWS_PROFILE=rds_user
aws sts get-caller-identity

HOSTNAME=ck-test.cluster-cvuwmcqqvylz.eu-central-1.rds.amazonaws.com
USER=ck-test
TOKEN=$(aws rds generate-db-auth-token --hostname $HOSTNAME --username $USER --port 3306)
mysql \
    --host $HOSTNAME \
    --user $USER \
    --password=$TOKEN \
    --enable-cleartext-plugin
