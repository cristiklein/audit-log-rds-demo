#!/bin/sh

set -xe

aws iam put-role-policy \
    --role-name ck-test \
    --policy-name rds-access \
    --policy-document file://rds-policy.json

mysql --defaults-extra-file=./mysql-root.cnf <<EOF
DROP USER IF EXISTS 'ck-test'@'%';
CREATE USER 'ck-test'@'%' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS';
GRANT ALL ON \`%\`.* TO 'ck-test'@'%';
EOF
