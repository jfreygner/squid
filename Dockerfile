FROM registry.redhat.io/ubi8/ubi

USER root

ADD files/files.tgz /

#RUN ping -c 1 -w 1 fresv07.freygner.local &> /dev/null || mv /etc/yum.repos.d/redhat.repo /etc/yum.repos.d/redhat.repo.sat && \

RUN ping -c 1 -w 1 fresv07.freygner.local &> /dev/null || { echo ping not ok; echo 10.1.1.226 >> /etc/hosts; } && \
    sed -i".ori" -e 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/subscription-manager.conf && \
    dnf -y update && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf -y install squid squidGuard && \
    dnf -y install procps-ng iputils iproute && \
    dnf -y clean all && \
    mv /etc/squid/squid.conf /etc/squid/squid.conf.ori && \
    rm -rf /etc/pki/entitlement/* && \
    mkdir /etc/squid/cm && \
    ln -s /etc/squid/cm/squid.conf /etc/squid/squid.conf && \
    chgrp -R root /etc/squid /var/run && \
    chmod -R g=u /var/run

VOLUME /var/spool/squid
VOLUME /var/log/squid

EXPOSE 8080

CMD ["/usr/sbin/squid","--foreground"]

USER 1001
