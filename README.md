# docker-jenkins-master



Jenkins master docker container. Specify SSH public/private keys when launching to enable access to repository server. Not specifying keys will mean you will have to manually enter these in to Jenkins.

If S3_BUCKET is specified (without s3://), a cron job will also be created to sync your jenkins home folder to and S3 bucket every 5 minutes.

## Use

```
docker run \
  -e "S3_BUCKET=URI-OF-S3-BUCKET" \
  -e "SSH_PRIVATE_KEY=BASE64/ENCODED/PRIVATE/KEY" \
  -e "SSH_KNOWN_HOSTS=github.com,192.30.252.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" \
  asynchrony/docker-jenkins-master
```
