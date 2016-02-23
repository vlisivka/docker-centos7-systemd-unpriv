#!/bin/bash
set -ue
# Script which will be run at startup of container
# Author: Volodymyr M. Lisivka <vlisivka@gmail.com>
# License: use for any purpose at your own risk.

# Systemd cannot use NSPAWN in non-privileged container
sed -i 's/PrivateTmp/#PrivateTmp/' /usr/lib/systemd/system/*.service

# Systemd cannot adjust out-of-memory killer in non-privileged container
sed -i 's/OOMScoreAdjust/#OOMScoreAdjust/' /usr/lib/systemd/system/*.service

# Execute kickstart scripts, if any, before systemd is started to make final adjustments.
# NOTE: For one time scripts, which must be ran once at start of the system,
# write a "first boot" systemd service and then enable it from a Dockerfile or from
# kickstart script.
for I in /kickstart.d/*.sh
do
  if [ -s "$I" ]; then
    "$I"
  fi
done

# Run systemd as PID 1
exec /usr/lib/systemd/systemd

# OR run systemd as regular process (zombie process will not be ripped in this case)
#/usr/lib/systemd/systemd --system --log-target=console --show-status=1

