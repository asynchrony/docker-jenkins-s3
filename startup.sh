cd ~

touch .ssh/id_rsa
cmhod 600 .ssh/id_rsa
echo $GIT_PRIVATE_KEY > .ssh/id_rsa

touch .ssh/id_rsa.pub
cmhod 600 .ssh/id_rsa.pub
echo $GIT_REPO_PUBLIC_KEY > .ssh/id_rsa.pub

if [ ! -f $GIT_IDEMPOTENCE_FLAG ]; then
  rm -rf .git # blow away any previous partially-failed checkout
  git init
  git remote add origin $GIT_ORIGIN
  git fetch
  # checkout and track branch, overwriting any existing differences
  git checkout --force $GIT_BRANCH --
  touch $GIT_IDEMPOTENCE_FLAG # indicate success
fi

exec /usr/local/bin/jenkins.sh
