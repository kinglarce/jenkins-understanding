#!/bin/bash

DATE=$(date +%H-%M-%S) # this is format for hour-minute-second in bash
BACKUP=db-$DATE.sql
DB_HOST=$1
DB_PASS=$2
DB_NAME=$3
AWS_SECRET=$4
BUCKET_NAME=$5

mysqldump -u root -h $DB_HOST -p$DB_PASS $DB_NAME > /tmp/$BACKUP && \
export AWS_ACCESS_KEY_ID=<ACCESS KEY ID> && \
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET && \
echo "Uploading $BACKUP"
aws s3 cp /tmp/$BACKUP s3://$BUCKET_NAME/$BACKUP


# /tmp/db_backup.sh db_host 1234 testdb 2Dw7nhAKloEfwbiJ3+xNo7kyOp5hL8DTCsThp17s jenkins-vm-mysql-backup