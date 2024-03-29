FROM registry.redhat.io/ubi9/ubi

USER root

ADD files/files.tgz /

#RUN ping -c 1 -w 1 fresv07.freygner.local &> /dev/null || mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.repo.sat && \

RUN [ ! -f /usr/bin/ping ] && \
    sed -i".ori" -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf && \
    { dnf install --nodocs -y iputils; dnf clean all; }

# echo lines are deactivated
RUN ping -c 1 -w 1 fresv07.freygner.local &> /dev/null || { echo ping not ok; echo 10.1.1.226 fresv07.freygner.local >> /etc/hosts; } && \
    ping -c 1 -w 1 fresv07.freygner.local && \
    sed -i".ori" -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf && \
    dnf -y --nodocs update && \
    echo NOT RUN dnf -y --nodocs install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    echo NOT RUN dnf -y --nodocs install squid squidGuard && \
    dnf -y --nodocs install squid && \
    dnf clean all && \
    mv /etc/squid/squid.conf /etc/squid/squid.conf.ori && \
    echo NOT RUN rm -rf /etc/pki/entitlement/* && \
    chgrp -R root /etc/squid /var/run && \
    chmod -R g=u /var/run

# remove for production images, activate rm -rf above
RUN dnf -y --nodocs install procps-ng iproute && \
    dnf clean all && \
    rm -rf /etc/pki/entitlement/*

VOLUME /var/spool/squid
VOLUME /var/log/squid

EXPOSE 8080

CMD ["/usr/sbin/squid","--foreground"]

USER 1001
