#!/bin/sh
set -e

if [ -n "$SSH_PRIVATE_KEY" ]; then
  mkdir -p ~/.ssh
  rm -f ~/.ssh/id_rsa
  echo "-----BEGIN RSA PRIVATE KEY-----" > ~/.ssh/id_rsa
  echo "$SSH_PRIVATE_KEY" >> ~/.ssh/id_rsa
  echo "-----END RSA PRIVATE KEY-----" >> ~/.ssh/id_rsa
  chmod 0400 ~/.ssh/id_rsa
fi
if [ -n "$SSH_KNOWN_HOSTS" ]; then
  mkdir -p ~/.ssh
  rm -f ~/.ssh/known_hosts
  echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
  chmod 0644 ~/.ssh/known_hosts
fi

cd ~
if [ ! -f $GIT_IDEMPOTENCE_FLAG ]; then
  rm -rf .git # blow away any previous partially-failed checkout
  git init
  git remote add origin $GIT_REPO
  git fetch
  # checkout and track branch, overwriting any existing differences
  git checkout --force $GIT_BRANCH --
  touch $GIT_IDEMPOTENCE_FLAG # indicate success
fi

exec /usr/local/bin/jenkins.sh
