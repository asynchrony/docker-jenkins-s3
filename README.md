# docker-jenkins-s3
# forked from docker-jenkins-s3

Jenkins master docker container. Specify SSH know_hosts/private keys when launching to enable access to repository server. If you do not start the container with these keys set, you will have to manually enter these in to Jenkins in order to access your repository.

```
docker run \
  -p 8080:8080 \
  -name jenkins
  -e "S3_BUCKET=URI-OF-S3-BUCKET" \
  -e "SSH_PRIVATE_KEY=KEY/WITH/NEWLINES/AND/HEADER/FOOTER/REMOVED" \
  -e "SSH_KNOWN_HOSTS=github.com,192.30.252.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" \
  asynchrony/docker-jenkins-s3
```

If `S3_BUCKET` is specified (without s3://), a cron job will also be created to sync your jenkins home folder to an S3 bucket every 5 minutes. Subsequent starts of the container will pull down the contents of the S3 bucket before starting Jenkins, thereby restoring all your jobs and settings. 

If `SSH_PRIVATE_KEY` is specified, the id_rsa file will be created in the ~/.ssh directory. This will allow Jenkins to connect to a repo without specifying credentials inside of Jenkins. The value should be the key, minus new lines and the header and footer. *Note, that certain Docker OSes (CoreOS) have a character limit for unit files that will cause the container to fail if the command is too long. So you may not be able to utilize this feature depending on how long your generated keys are.*

If `SSH_KNOWN_HOSTS` is specified, you will not need to authorize Jenkins to connect to your repository manually the first time.

The docker host must have an IAM instance profile assigned, and it must allow it to access the S3 bucket. Failure to do either will cause the sync, as well as the container to fail. If you do not wish to use this feature, simply do not set the S3_BUCKET environment variable.


# Use with Jenkins Nodes on same host

```
docker run \
  -p 8080:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name jenkins \
  -e "S3_BUCKET=URI-OF-S3-BUCKET" \
  -e "SSH_PRIVATE_KEY=BASE64/ENCODED/PRIVATE/KEY" \
  -e "SSH_KNOWN_HOSTS=github.com,192.30.252.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" \
  asynchrony/docker-jenkins-s3
```

If you wish to spawn jenkins worker node on the same host, include the docker.sock volume so you can access docker from within the container.
After that, a worker can be spawned by using the Launch method of `Launch agent via execution of command on the master`:
```
docker run -i --rm --name jenkins-agent -v jenkins-agent:/home/jenkins/agent jenkinsci/slave:alpine java -jar /usr/share/jenkins/slave.jar -workDir /home/jenkins/agent
```
Make sure to set the Remote root directory to `/home/jenkins/agent`

A Worker container spawned in this way is a child of the jenkins master container, and `will be terminated if you terminate the jenkins master container`. If you are using S3 backups, this agent should be restored once the master container has fully initialized again.


# JNLP Slaves (Java Web Start)

```
docker run \
  -p 8080:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name jenkins \
  -e "S3_BUCKET=URI-OF-S3-BUCKET" \
  -e "SSH_PRIVATE_KEY=KEY/WITH/NEWLINES/AND/HEADER/FOOTER/REMOVED" \
  -e "SSH_KNOWN_HOSTS=github.com,192.30.252.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" \
  asynchrony/docker-jenkins-s3
```

If you are using JNLP slaves, then you will need to map port 50000 through to the host. All master/slave comms will go through this port. You Jenkins master will also need a Route53 DNS entry so that slaves can locate it across the internet.

This is a good image for creating slaves that reside outside of the AWS account your Jenkins Master is in.

[jenkinsci/jnlp-slave](https://hub.docker.com/r/jenkinsci/jnlp-slave/)



