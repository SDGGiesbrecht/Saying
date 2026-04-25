FROM amazonlinux:2
RUN yum groupinstall --assumeyes "Development Tools"
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
