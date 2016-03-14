FROM centos:6

RUN curl -sL -o /etc/yum.repos.d/jfroche-libvmod-cookie.repo https://copr.fedoraproject.org/coprs/jfroche/libvmod-cookie/repo/epel-6/jfroche-libvmod-cookie-epel-6.repo && \
    yum install -y epel-release && \
    yum localinstall -y https://repo.varnish-cache.org/redhat/varnish-4.1.el6.rpm && \
    yum install -y libvmod-cookie

COPY ./default-test.vcl /etc/varnish/default.vcl
CMD ["varnishd", "-F", "-a", "0.0.0.0:5000", "-f", "/etc/varnish/default.vcl"]
