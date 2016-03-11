#!/bin/bash
set -ue

# Systemd cannot use NSPAWN in non-privileged container
for FILE in $(grep --files-with-matches '^PrivateTmp=' /usr/lib/systemd/system/*.service)
do
  SERVICE="$(basename "$FILE")"
  OVERRIDE_DIR="/etc/systemd/$SERVICE.d"
  mkdir -p "$OVERRIDE_DIR"
  echo -e "[service]\nPrivateTmp=no" >"$OVERRIDE_DIR"/disable-private-tmp.conf
done
