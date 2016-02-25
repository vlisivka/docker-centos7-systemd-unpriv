Name:           docker-centos7-systemd-unpriv
Version:        0.0.0master
Release:        1%{?dist}
Summary:        Strip down systemd and modify services to run in unprivileged container.

License:        GPLv2
URL:            https://github.com/vlisivka/docker-centos7-systemd-unpriv
Source0:        https://github.com/vlisivka/docker-centos7-systemd-unpriv/archive/master.tar.gz#/docker-centos7-systemd-unpriv-master.tar.gz
Buildarch:      noarch

Requires:       systemd, systemd-libs, sed, findutils

%description
Install this package into container with systemd to be able to run it as unprivileged container.

In Docker file, use CMD ["/usr/sbin/init.sh"] to start container.

Place scripts, which must be executed before systemd, into /etc/kickstart.d/ directory.

%prep
%setup -qn docker-centos7-systemd-unpriv-master

%build
: # Nothing to do

%install
rm -rf $RPM_BUILD_ROOT

cp -a files/ "$RPM_BUILD_ROOT"/

%files
%defattr(-,root,root,-)
%doc README.md

%dir /etc/kickstart.d/

/etc/kickstart.d/*.sh
/usr/sbin/*.sh

%changelog
* Thu Feb 25 2016 Volodymyr M. Lisivka
- Initial release
