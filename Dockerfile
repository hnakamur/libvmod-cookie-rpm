FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

RUN yum -y install epel-release \
 && yum -y install rpmdevtools rpm-build patch python-pip rpmlint \
 && pip install copr-cli==1.46.1 progress==1.2 \
 && rpmdev-setuptree

COPY ./libvmod-cookie.spec /root/rpmbuild/SPECS/
RUN spectool --all -g /root/rpmbuild/SPECS/libvmod-cookie.spec -C /root/rpmbuild/SOURCES

WORKDIR /root/rpmbuild/SPECS
RUN rpmbuild -bs libvmod-cookie.spec

COPY copr-build.sh /root/
WORKDIR /root
ENV HOME /root
ENTRYPOINT ["/bin/bash", "/root/copr-build.sh"]
