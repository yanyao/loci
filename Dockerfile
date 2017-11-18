ARG FROM=ubuntu:xenial
FROM ${FROM}

ENV PATH=/var/lib/openstack/bin:$PATH
ARG PROJECT
ARG WHEELS=openstackloci/requirements:master-ubuntu
ARG PROJECT_REPO=https://github.com/openstack/${PROJECT}
ARG PROJECT_REF=master
ARG DISTRO
ARG PROFILES
ARG PIP_PACKAGES
ARG PLUGIN=no
ARG PYTHON3=no
ARG EXTRA_PIP_PACKAGES
COPY scripts /opt/loci/scripts
COPY bindep.txt /opt/loci/
COPY ${PROJECT}/etc /etc
COPY ${PROJECT}/init.sh /

RUN /opt/loci/scripts/install.sh

ENTRYPOINT ["/init.sh"]
