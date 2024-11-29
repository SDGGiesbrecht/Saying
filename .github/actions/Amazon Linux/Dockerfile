FROM amazonlinux:2
RUN yum install --assumeyes gcc
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
