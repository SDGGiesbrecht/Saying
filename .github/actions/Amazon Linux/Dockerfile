FROM amazonlinux:2
RUN yum groupinstall --assumeyes "Development Tools"
RUN yum install --assumeyes glib2-devel
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
