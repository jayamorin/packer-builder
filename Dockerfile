FROM ubuntu:18.04

ENV VIRTUALBOX_VERSION="v1.13.4"
ENV PACKER_VERSION="v2.13.0"
ENV VAGRANT_VERSION="2.2.5"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
 wget \
 curl \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb \
 && sha256sum vagrant_${VAGRANT_VERSION}_x86_64.deb \
 | grep $(curl -s https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_SHA256SUMS) \
 && dpkg -i vagrant_${VAGRANT_VERSION}_x86_64.deb \
 && rm -rf vagrant_${VAGRANT_VERSION}_x86_64.deb
