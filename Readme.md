This extension to the [strider_simple](https://registry.hub.docker.com/u/ikkyotech/strider_simple/) will automatically backup the database in a hourly interval to s3 and upon start download the latest backup.

To launch an instance you have to pass in your AWS credentials as environment variables like:

```
$ docker run -p 3000:3000 \
    -e BACKUP_S3_BUCKET="<your bucket>" \
    -e BACKUP_S3_PREFIX="strider_" \
    -e AWS_ACCESS_ID="<access key>" \
    -e AWS_SECRET_KEY="<secret key>" \
```
