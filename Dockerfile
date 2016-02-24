FROM docker.io/centos:7
MAINTAINER Volodymyr M. Lisivka <vlisivka@gmail.com>

# Systemd needs /sys/fs/cgroup directoriy to be mounted from host in
# read-only mode.
VOLUME /sys/fs/cgroup

# Systemd needs /run directory to be a mountpoint, otherwise it will try
# to mount tmpfs here (and will fail).
VOLUME /run

# Copy initialization script, which will execute kickstart and then start systemd as pid 1
COPY files/ /

# Run systemd by default via init.sh script, to start required services.
CMD ["/usr/local/sbin/init.sh"]

# Run container with "--stop-signal=$(kill -l RTMIN+3)" option to
# shutdown container using "docker stop CONTAINER", OR run
# /usr/local/sbin/shutdown.sh script as root from container and then kill
# container using "docker kill CONTAINER".
