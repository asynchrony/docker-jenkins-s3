FROM jenkins:alpine

USER root


RUN apk add --no-cache su-exec python py-pip \
    && pip install awscli

COPY run-jenkins.sh /usr/local/bin/run-jenkins.sh

ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/local/bin/run-root.sh"]
