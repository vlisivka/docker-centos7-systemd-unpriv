FROM centos:7
MAINTAINER Volodymyr M. Lisivka <vlisivka@gmail.com>

# Systemd needs these directories to be mounted from host
VOLUME /sys/fs/cgroup
VOLUME /run

# No longer necessary: systemd-container-208.20-6.el7.centos.x86_64 is installed already.
## Install real systemd instead of fakesystemd
#RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs initscripts

# Mask (create override which points to /dev/null) system services, which
# cannot be started in container anyway.
RUN systemctl mask \
    dev-mqueue.mount \
    dev-hugepages.mount \
    remote-fs.target \
    systemd-remount-fs.service \
    sys-kernel-config.mount \
    sys-kernel-debug.mount \
    sys-fs-fuse-connections.mount \
    systemd-ask-password-wall.path \
    systemd-readahead-collect.service \
    systemd-readahead-replay.service \
    systemd-sysctl.service \
    display-manager.service \
    systemd-logind.service \
    network.service \
    getty.service

# Change target init stage from from graphical mode to multiuser text-only mode
RUN systemctl disable graphical.target && systemctl enable multi-user.target

# Copy initialization script, which will execute kickstart and then start systemd as pid 1
COPY init.sh /

# Run systemd by default via init.sh script, to start required services
CMD ["/init.sh"]
