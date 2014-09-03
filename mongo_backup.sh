#!/bin/bash
DATE=$(date -u "+%F-%H%M%S")
BACKUP_NAME="$BACKUP_S3_PREFIX$DATE.tar.gz"
BACKUP_FOLDER="/tmp/$BACKUP_S3_PREFIX$DATE"
BACKUP_FILE="/tmp/$BACKUP_NAME"

echo "Dumping the database to $BACKUP_FOLDER"
mongodump --journal --out "$BACKUP_FOLDER"

cd "$BACKUP_FOLDER"
echo "Compressing $BACKUP_FOLDER -> $BACKUP_FILE..."
tar -zcvf "$BACKUP_FILE" *

echo "Uploading $BACKUP_FILE to s3"
s3cmd put --config /.s3cfg $BACKUP_FILE "s3://$BACKUP_S3_BUCKET/$BACKUP_NAME"

echo "Cleaning $BACKUP_FOLDER and $BACKUP_FILE"
rm -rf $BACKUP_FOLDER
rm -r  $BACKUP_FILE