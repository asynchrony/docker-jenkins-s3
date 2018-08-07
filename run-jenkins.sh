#!/bin/sh
set -e

if [ -n "$SSH_PRIVATE_KEY" ]; then
  mkdir -p ~/.ssh
  rm -f ~/.ssh/id_rsa
  echo "-----BEGIN RSA PRIVATE KEY-----" > ~/.ssh/id_rsa
  echo "$SSH_PRIVATE_KEY" | fold -w 64 >> ~/.ssh/id_rsa
  echo "-----END RSA PRIVATE KEY-----" >> ~/.ssh/id_rsa
  chmod 0400 ~/.ssh/id_rsa
fi
if [ -n "$SSH_KNOWN_HOSTS" ]; then
  mkdir -p ~/.ssh
  rm -f ~/.ssh/known_hosts
  echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
  chmod 0644 ~/.ssh/known_hosts
fi

if [ -n "$S3_BUCKET" ]; then
  echo "Setting up S3-Sync"
  chmod +x /usr/local/bin/s3-sync.sh
  touch /var/log/s3-sync.log

  echo "Doing initial sync with S3"
  /usr/bin/aws s3 sync s3://$S3_BUCKET /var/jenkins_home --exclude "*caches/*" --exclude "*workspace/*" --exclude "*workspace/*" --exclude "*lastSuccessfulBuild/*" --exclude "*lastStableBuild/*" --exclude "*lastFailedBuild/*" --exclude "*lastUnsuccessfulBuild/*"

  echo "*/60 * * * * /usr/local/bin/s3-sync.sh > /var/log/s3-sync.log" | /usr/bin/crontab -
  echo "Ensure Crond is running in background"
  /usr/sbin/crond
fi

chown jenkins /var/jenkins_home
exec /usr/local/bin/jenkins.sh
