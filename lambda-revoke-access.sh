#!/bin/sh

set -xe

aws iam delete-role-policy \
    --role-name ck-test \
    --policy-name rds-access || true

mysql --defaults-extra-file=./mysql-root.cnf <<EOF
DROP USER IF EXISTS 'ck-test'@'%';
FLUSH PRIVILEGES;
EOF

THREADS_TO_KILL=$(
mysql --defaults-extra-file=./mysql-root.cnf --skip-column-names <<EOF
SELECT id FROM information_schema.processlist WHERE user='ck-test';
EOF
)

for THREAD_TO_KILL in $THREADS_TO_KILL; do
    mysql --defaults-extra-file=./mysql-root.cnf -e "CALL mysql.rds_kill($THREAD_TO_KILL)"
done
