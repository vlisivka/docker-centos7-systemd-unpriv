#!/bin/bash
set -ue

# Create configuration file for journald.
mkdir -p /etc/systemd/journald.conf.d
echo >/etc/systemd/journald.conf.d/forward-log-to-console.conf "
[Journal]
#Storage=none
ForwardToConsole=yes
# Docker -t option is necessary for /dev/console.
#TTYPath=/dev/console
"

# NOTE: File is created at runtime with goal to not affect hw/vm based
# system when installed as RPM package as dependency to a package.

# NOTE: If you need to alter options of journald, just create your own
# .conf file in /etc/systemd/journald.conf.d directory.
