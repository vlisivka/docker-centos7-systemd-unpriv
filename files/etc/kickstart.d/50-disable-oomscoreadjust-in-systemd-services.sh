#!/bin/bash
set -ue

# Systemd cannot adjust score for kernel Out Of Memory Killer in non-privileged container

for FILE in $(grep --files-with-matches '^OOMScoreAdjust=' /usr/lib/systemd/system/*.service)
do
  SERVICE="$(basename "$FILE")"
  OVERRIDE_DIR="/etc/systemd/$SERVICE.d"
  mkdir -p "$OVERRIDE_DIR"
  echo -e "[service]\nOOMScoreAdjust=0" >"$OVERRIDE_DIR"/disable-oomscore-adjust.conf
done
