#!/bin/bash
set -ue
# Script which will be run at startup of container
# Author: Volodymyr M. Lisivka <vlisivka@gmail.com>
# License: GPLv2

(( $$ == 1 )) || {
  echo "ERROR: Script must be ran as PID 1, via 'CMD [\"/usr/sbin/init.sh\"]' entry in Dockerfile." >&2
  exit 1
}

# Execute kickstart scripts, if any, before systemd is started to make final adjustments.
# NOTE: For one time scripts, which must be ran once at start of the system,
# write a "first boot" systemd service and then enable it from a Dockerfile or from
# kickstart script.
for I in /etc/kickstart.d/*.sh
do
  if [ -s "$I" ]
  then
    "$I" || {
      echo "ERROR: An error in \"$I\" kickstart script: non-zero exit code returned: $?." >&2
      exit 1 # Fail fast
    }
  fi
done

# Run systemd as PID 1
exec /usr/lib/systemd/systemd

# OR run systemd as regular process (zombie process will not be ripped in this case)
#/usr/lib/systemd/systemd --system --log-target=console --show-status=1

