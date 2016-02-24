#!/bin/bash
set -ue

# Mask (create override which points to /dev/null) system services, which
# cannot be started in container anyway.
exec systemctl mask \
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
    systemd-udevd-kernel.socket
