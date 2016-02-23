FROM docker.io/centos:7
MAINTAINER Volodymyr M. Lisivka <vlisivka@gmail.com>

# Systemd needs /sys/fs/cgroup directoriy to be mounted from host in
# read-only mode.
VOLUME /sys/fs/cgroup

# Systemd needs /run directory to be a mountpoint, otherwise it will try
# to mount tmpfs here (and will fail).
VOLUME /run

# Set TERM variable for console programs
ENV TERM xterm

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
    getty.service \
    getty@tty1.service \
    proc-sys-fs-binfmt_misc.automount \
    kmod-static-nodes.service \
    rhel-autorelabel.service \
    rhel-autorelabel-mark.service \
    rhel-dmesg.service \
    rhel-import-state.service \
    rhel-loadmodules.service \
    systemd-binfmt.service \
    systemd-hwdb-update.service \
    systemd-machine-id-commit.service \
    systemd-modules-load.service \
    systemd-tmpfiles-setup-dev.service \
    systemd-udev-trigger.service \
    systemd-udevd.service \
    systemd-vconsole-setup.service \
    system-getty.slice \
    systemd-udevd-control.socket \
    systemd-udevd-kernel.socket && \
# Remove broken link 
    rm -f /usr/lib/systemd/system/dbus-org.freedesktop.network1.service && \

# Change target init stage from from graphical mode to multiuser text-only mode
    systemctl set-default multi-user.target

# Copy initialization script, which will execute kickstart and then start systemd as pid 1
COPY files/ /

# Run systemd by default via init.sh script, to start required services.
CMD ["/usr/local/sbin/init.sh"]

# Run container with "--stop-signal=$(kill -l RTMIN+3)" option to
# shutdown container using "docker stop CONTAINER", OR run
# /usr/local/sbin/shutdown.sh script as root from container and then kill
# container using "docker kill CONTAINER".
