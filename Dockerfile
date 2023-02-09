FROM registry.redhat.io/ubi9/ubi:9.1

USER root

ADD files/files.tgz /

#RUN ping -c 1 -w 1 fresv07.freygner.local &> /dev/null || mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.repo.sat && \

RUN [ ! -f /usr/bin/ping ] && \
    sed -i".ori" -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf && \
    { dnf install --nodocs -y iputils; dnf clean all; }

# echo lines are deactivated
RUN ping -c 1 -w 1 fresv07.freygner.local &> /dev/null || { echo ping not ok; echo 10.1.1.226 >> /etc/hosts; } && \
    sed -i".ori" -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf && \
    dnf -y --nodocs update && \
    echo dnf -y --nodocs install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    echo dnf -y --nodocs install squid squidGuard && \
    dnf -y --nodocs install squid && \
    dnf -y clean all && \
    mv /etc/squid/squid.conf /etc/squid/squid.conf.ori && \
    echo rm -rf /etc/pki/entitlement/* && \
    mkdir /etc/squid/cm && \
    chgrp -R root /etc/squid /var/run && \
    chmod -R g=u /var/run

# remove for production images, activate rm -rf above
RUN dnf -y --nodocs install procps-ng iproute && \
    dnf -y clean all && \
    rm -rf /etc/pki/entitlement/*

VOLUME /var/spool/squid
VOLUME /var/log/squid

EXPOSE 8080

CMD ["/usr/sbin/squid","--foreground"]

USER 1001
