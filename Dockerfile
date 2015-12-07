FROM centos:7
MAINTAINER Hiroaki Nakamura <hnakamur@gmail.com>

ENV LIBVMOD_COOKIE_GIT_BRANCH 4.1

RUN yum -y install epel-release \
 && yum -y install rpmdevtools rpm-build patch python-pip \
 && pip install copr-cli \
 && rpmdev-setuptree \
 && cd /root/rpmbuild/SOURCES \
 && curl -sLO https://github.com/lkarsten/libvmod-cookie/archive/${LIBVMOD_COOKIE_GIT_BRANCH}.tar.gz#/libvmod-cookie-${LIBVMOD_COOKIE_GIT_BRANCH}.tar.gz

ADD libvmod-cookie.spec /root/rpmbuild/SPECS/

RUN cd /root/rpmbuild/SPECS \
 && rpmbuild -bs libvmod-cookie.spec

ADD copr-build.sh /root/
ENTRYPOINT ["/bin/bash", "/root/copr-build.sh"]
