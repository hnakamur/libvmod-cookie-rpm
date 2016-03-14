#!/bin/bash
set -xe
# shellcheck disable=SC2153
copr_login=$COPR_LOGIN
# shellcheck disable=SC2153
copr_username=$COPR_USERNAME
copr_token=$COPR_PWD

project_name=libvmod-cookie
spec_file=/root/rpmbuild/SPECS/libvmod-cookie.spec

mkdir -p /root/.config
cat > /root/.config/copr <<EOF
[copr-cli]
login = ${copr_login}
username = ${copr_username}
token = ${copr_token}
copr_url = https://copr.fedoraproject.org
EOF

status=$(curl -s -o /dev/null -w "%{http_code}" https://copr.fedoraproject.org/api/coprs/"${copr_username}"/"${project_name}"/detail/)
if [ "$status" = "404" ]; then
# shellcheck disable=SC2016
  copr-cli create --chroot epel-6-x86_64 \
--repo 'https://repo.varnish-cache.org/redhat/varnish-4.1/el6/$basearch' \
--description \
'A Varnish module for simpler use of the cookie header.' \
--instructions \
"sudo curl -sL -o /etc/yum.repos.d/${copr_username}-${project_name}.repo https://copr.fedoraproject.org/coprs/${copr_username}/${project_name}/repo/epel-6/${copr_username}-${project_name}-epel-6.repo
sudo yum install ${project_name}" \
${project_name}
fi
version=$(awk '$1=="Version:" {print $2}' ${spec_file})
release=$(rpm --eval "$(awk '$1=="Release:" {print $2}' ${spec_file})")
srpm_file=/root/rpmbuild/SRPMS/${project_name}-${version}-${release}.src.rpm
copr-cli build --nowait "${project_name}" "${srpm_file}"
echo "Check https://copr.fedorainfracloud.org/coprs/jfroche/libvmod-cookie/"
