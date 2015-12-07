%global libvmod_cookie_git_branch 4.1

Name:              libvmod-cookie
Version:           20151207
Release:           1%{?dist}
Summary:           Varnish Cookie VMOD
License:           FreeBSD
Source:            https://github.com/lkarsten/libvmod-cookie/archive/%{libvmod_cookie_git_branch}.tar.gz#/libvmod-cookie-%{libvmod_cookie_git_branch}.tar.gz
URL:               https://www.varnish-cache.org/vmod/cookie
Requires:          varnish >= 4.1.0
BuildRequires:     varnish-libs-devel >= 4.1.0
BuildRequires:     git
BuildRequires:     automake
BuildRequires:     autoconf
BuildRequires:     libtool
BuildRequires:     python-docutils

%description
Varnish VMOD for Cookie.

Functions to handle the content of the Cookie header without complex use of regular expressions.
Parses a cookie header into an internal data store, where per-cookie get/set/delete functions are available. A filter_except() method removes all but a set comma-separated list of cookies.

A convenience function for formatting the Set-Cookie Expires date field is also included. It might be needed to use libvmod-header if there might be multiple Set-Cookie response headers.

%prep
%setup -q -n %{name}-%{libvmod_cookie_git_branch}

%build
./autogen.sh
./configure --prefix=%{_prefix}
make

%install
make install DESTDIR=%{buildroot}
rm %{buildroot}%{_libdir}/varnish/vmods/libvmod_cookie.la

%files
%doc %{_docdir}/libvmod-cookie/LICENSE
%doc %{_docdir}/libvmod-cookie/README.rst
%doc %{_mandir}/man3/vmod_cookie.3.gz
%{_libdir}/varnish/vmods/libvmod_cookie.so

%changelog
* Mon Dec  7 2015 Hiroaki Nakamura <hnakamur@gmail.com> - 20151207-1
- Initial package using commit b140c7acedd8fe2133751cc01cadd2239e7f2f1e
