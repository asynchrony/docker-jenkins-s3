#!/bin/sh
set -e

chown -R jenkins /var/jenkins_home
su-exec jenkins /usr/local/bin/run-jenkins.sh
