FROM jenkins

ENV GIT_IDEMPOTENCE_FLAG .git/chef.flag
ENV GIT_BRANCH master

COPY startup.sh /usr/local/bin/startup.sh

ENTRYPOINT ["/bin/tini", "--"]

CMD ["/usr/local/bin/startup.sh"]
