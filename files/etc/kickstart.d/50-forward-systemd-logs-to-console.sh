#!/bin/bash
set -ue

# Create configuration file for systemd.
mkdir -p /etc/systemd/system.conf.d/
echo >/etc/systemd/system.conf.d/forward-log-to-console.conf "
[Manager]
#LogLevel=info
LogTarget=console
#LogColor=yes
#LogLocation=no
"

# NOTE: File is created at runtime with goal to not affect hw/vm based
# system when installed as RPM package as dependency to a package.

# NOTE: If you need to alter options of systemd, just create your own
# .conf file in /etc/systemd/system.conf.d directory.
