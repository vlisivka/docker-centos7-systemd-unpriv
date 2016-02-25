#!/bin/bash
set -ue

# Remove broken links in /usr/lib/systemd/system directory, because sed
# command will refuse to do replaces otherwise.
exec find /usr/lib/systemd/system -type l -name '*.service' -! -exec test -e {} \; -delete
