FROM jenkins/jenkins:lts-alpine

USER root

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/main' >> /etc/apk/repositories \
 && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.6/community' >> /etc/apk/repositories

RUN addgroup -g 233 docker \
 && apk add --no-cache \
      docker \
      py2-pip \
      python \
      shadow \
 && pip install --no-cache-dir \
      awscli \
      docker-compose \
 && usermod -a -G docker jenkins \
 && docker --version \
 && git --version \
 && aws --version

COPY run-jenkins.sh /usr/local/bin/run-jenkins.sh
COPY s3-sync.sh /usr/local/bin/s3-sync.sh

ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/local/bin/run-jenkins.sh"]
