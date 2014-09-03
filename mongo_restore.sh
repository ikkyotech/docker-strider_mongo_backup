#!/bin/bash

echo "Loading available backups \"s3://$BACKUP_S3_BUCKET/$BACKUP_S3_PREFIX\""
S3_FILE=$(s3cmd ls s3://$BACKUP_S3_BUCKET/$BACKUP_S3_PREFIX | tail -1 | awk '{print $4}')
TMP_PATH=/tmp/mongo_backup_latest
BACKUP_FILE=/tmp/mongo_backup_latest.tar.gz

if [[ ! -z "$S3_FILE" ]]; then
    echo "Deleting former backups if they exist"
    rm -rf "$TMP_PATH"
    rm -rf "$BACKUP_FILE"

    echo "Downloading the latest backup ($S3_FILE) to $BACKUP_FILE"
    s3cmd get "$S3_FILE" "$BACKUP_FILE"

    mkdir -p "$TMP_PATH"

    echo "Extracting the backup"
    tar -C "$TMP_PATH" -zxvf "$BACKUP_FILE"

    echo "Restoring the template from $TMP_PATH"
    mongorestore --dbpath /data/db "$TMP_PATH"

    echo "Cleaning temporary path"
    rm -rf "$BACKUP_FILE"
    rm -rf "$TMP_PATH"
else
    echo "No backup found."
fi