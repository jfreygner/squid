FROM registry.redhat.io/ubi8/ubi

USER root

COPY files/etc-pki-entitlement /etc/pki/entitlement

COPY files/redhat.repo /etc/yum.repos.d

RUN dnf -y update && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf -y install squid squidGuard && \
    dnf -y clean all

COPY files/squid.conf /etc/squid/squid.conf

RUN chgrp -R root /etc/squid /var/log/squid /var/spool/squid /var/run/squid && \
	chmod -R g=u /var/log/squid /var/spool/squid /run

VOLUME /var/spool/squid
VOLUME /var/log

EXPOSE 8080

CMD ["/usr/sbin/squid","--foreground"]

USER 1001
