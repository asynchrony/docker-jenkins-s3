#!/bin/sh
set -e

if ! keytool -list -keystore "/etc/pki/java/cacerts" -storepass "changeit" -alias "dc0-stl.schafer.lan.64.cer" ; then
  mkdir ~/s3files
  cd ~/s3files
  aws s3 sync . s3://fite-jenkins-config/dc0-stl.schafer.lan.64.cer
  keytool -import -trustcacerts -alias "dc0-stl.schafer.lan.64.cer" -file "~/s3files/dc0-stl.schafer.lan.64.cer" -keystore "/etc/pki/java/cacerts" -storepass "changeit" -noprompt
fi

chown -R jenkins /var/jenkins_home
su-exec jenkins /usr/local/bin/run-jenkins.sh
