FROM ubuntu:18.04

ENV packer_version="1.4.2"
ENV virtualbox_version="6.0"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget \
    curl \
    unzip \
    ca-certificates \
    software-properties-common \
    git

RUN wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add - \
 && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add - \
 && add-apt-repository -y "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	virtualbox-${virtualbox_version} \
 && rm -rf /var/lib/apt/lists/*

RUN vbox_version=$(dpkg -l | grep virtualbox | awk '{print $3}' | sed -e 's/\([0-9\.]*\)\-.*/\1/') ; \
    wget http://download.virtualbox.org/virtualbox/${vbox_version}/Oracle_VM_VirtualBox_Extension_Pack-${vbox_version}.vbox-extpack \
 && echo "y" | VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-${vbox_version}.vbox-extpack \
 && /sbin/vboxconfig \
 && rm -f Oracle_VM_VirtualBox_Extension_Pack-${vbox_version}.vbox-extpack

RUN wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip \
 && curl -s https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_SHA256SUMS \
 | grep $(sha256sum packer_${packer_version}_linux_amd64.zip | awk '{print $1}') \
 && unzip packer_${packer_version}_linux_amd64.zip \
 && mv packer /usr/local/bin/packer \
 && chmod +x /usr/local/bin/packer \
 && rm -f packer_${packer_version}_linux_amd64.zip

ENTRYPOINT ["/usr/local/bin/packer"]

CMD ["--help"]
