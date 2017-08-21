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
  echo "*/5 * * * * /usr/local/bin/s3-sync.sh > /var/log/s3-sync.log" | /usr/bin/crontab -
  echo "Doing initial sync with S3"
  /usr/local/bin/s3-sync.sh
fi

chown jenkins /var/jenkins_home
exec /usr/local/bin/jenkins.sh
