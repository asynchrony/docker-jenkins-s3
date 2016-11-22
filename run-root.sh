#!/bin/sh
set -e

KEYSTORE="/etc/ssl/certs/java/cacerts"
LDAPCERT="dc0-stl.schafer.lan.64.cer"
STOREPASSWORD="changit"

if ! keytool -list -keystore $KEYSTORE -storepass $STOREPASSWORD -alias $LDAPCERT ; then
  mkdir ~/s3files
  cd ~/s3files
  aws s3 cp s3://fite-jenkins-config/$LDAPCERT .
  keytool -import -trustcacerts -alias $LDAPCERT -file ~/s3files/$LDAPCERT -keystore $KEYSTORE -storepass $STOREPASSWORD -noprompt
fi

chown -R jenkins /var/jenkins_home
su-exec jenkins /usr/local/bin/run-jenkins.sh
