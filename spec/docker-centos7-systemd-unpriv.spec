
# Build release branch as:
#   spectool -g --debug --sourcedir --define 'VERSION 1.0'  docker-centos7-systemd-unpriv.spec
#   rpmbuild -bb --define 'VERSION 1.0' docker-centos7-systemd-unpriv.spec

# v1.0 or master
%define git_branch %{?VERSION:v%VERSION}%{!?VERSION:master}
# 1.0 or 0.0.0
%define git_version %{?VERSION}%{!?VERSION:0.0.0}
# 1.0 or master
%define tar_dir_tag %{?VERSION}%{!?VERSION:master}

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
%setup -qn docker-centos7-systemd-unpriv-%{tar_dir_tag}

%build
: # Nothing to do

%install
rm -rf $RPM_BUILD_ROOT

cp -a files/ "$RPM_BUILD_ROOT"/

%files
%defattr(-,root,root,-)
%doc README.md LICENSE

%dir /etc/mask.d
/etc/mask.d/*

%dir /etc/kickstart.d/
/etc/kickstart.d/*.sh

/usr/sbin/*.sh

%changelog
* Thu Feb 25 2016 Volodymyr M. Lisivka
- Initial release
