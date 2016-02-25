
# Build release branch as:
#   spectool -g --debug --sourcedir --define 'BRANCH v1.0' --define 'VERSION 1.0'  docker-centos7-systemd-unpriv.spec
#   rpmbuild -bb --define 'BRANCH v1.0' --define 'VERSION 1.0' docker-centos7-systemd-unpriv.spec

%define git_branch %{?BRANCH}%{!?BRANCH:master}
%define git_version %{?VERSION}%{!?VERSION:0.0.0}

Name:           docker-centos7-systemd-unpriv
Version:        %{git_version}
Release:        1%{?dist}
Summary:        Strip down systemd and modify services to run in unprivileged container.

License:        GPLv2
URL:            https://github.com/vlisivka/docker-centos7-systemd-unpriv
Source0:        https://github.com/vlisivka/docker-centos7-systemd-unpriv/archive/%{git_branch}.tar.gz#/docker-centos7-systemd-unpriv-%{git_branch}.tar.gz
Buildarch:      noarch

Requires:       systemd, systemd-libs, sed, findutils

%description
Install this package into container with systemd to be able to run it as unprivileged container.

In Docker file, use CMD ["/usr/sbin/init.sh"] to start container.

Place scripts, which must be executed before systemd, into /etc/kickstart.d/ directory.

%prep
%setup -qn docker-centos7-systemd-unpriv-%{git_branch}

%build
: # Nothing to do

%install
rm -rf $RPM_BUILD_ROOT

cp -a files/ "$RPM_BUILD_ROOT"/

%files
%defattr(-,root,root,-)
%doc README.md

%dir /etc/mask.d
/etc/mask.d/*

%dir /etc/kickstart.d/
/etc/kickstart.d/*.sh

/usr/sbin/*.sh

%changelog
* Thu Feb 25 2016 Volodymyr M. Lisivka
- Initial release
