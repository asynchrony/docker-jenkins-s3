if [ -n "$S3_BUCKET" ]; then
  /usr/local/bin/aws s3 sync /var/jenkins_home s3://$S3_BUCKET --sse AES256 --debug
fi