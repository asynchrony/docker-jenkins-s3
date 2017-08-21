FROM jenkins:alpine

USER root

RUN addgroup -g 233 docker \
 && apk add --no-cache \
      docker \
      py2-pip \
      python \
      shadow \
 && pip install --no-cache-dir \
      awscli \
 && usermod -a -G docker jenkins \
 && docker --version \
 && git --version \
 && aws --version

COPY run-jenkins.sh /usr/local/bin/run-jenkins.sh

ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/local/bin/run-root.sh"]
