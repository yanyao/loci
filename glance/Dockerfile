ARG FROM=ubuntu:xenial
FROM ${FROM}
MAINTAINER yanwei.yao@me.com

ENV PATH=/var/lib/openstack/bin:$PATH
ARG PROJECT
ARG WHEELS=openstackloci/requirements:master-ubuntu
ARG PROJECT_REPO=https://git.openstack.org/openstack/${PROJECT}
ARG PROJECT_REF=master
ARG DISTRO
ARG PROFILES
ARG PIP_PACKAGES
ARG PLUGIN=no
ARG PYTHON3=no
COPY scripts /opt/loci/scripts
COPY bindep.txt /opt/loci/
COPY init.sh /init.sh
COPY etc /etc

RUN /opt/loci/scripts/install.sh
ENTRYPOINT [ "/init.sh"]
