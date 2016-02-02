This is image of CentOS7 with systemd installed, which can be ran in unprivileged mode, for example:

    docker run -d  -v /sys/fs/cgroup:/sys/fs/cgroup:ro vlisivka/centos7-systemd-unpriv

It contains initialization script /init.sh, which allows of fine tuning of container before systemd is started via /kickstart.d/ directory:

    #!/bin/bash
    set -uex
    # Script which will be run at startup of container
    # Author: Volodymyr M. Lisivka <vlisivka@gmail.com>
    # License: use for any purpose at your own risk.
    
    # (Fix for Docker 1.5)
    # Container inherits limit on number of opened files from Docker, which is very high (1M),
    # so return it back to sane 1K limit, otherwise processes in container will use too much memory
    # (size of file descriptor * 1M per each process).
    ulimit -n 1024

    # Systemd cannot use NSPAWN in non-privileged container
    sed -i 's/PrivateTmp/#PrivateTmp/' /usr/lib/systemd/system/*.service

    # Systemd cannot adjust out-of-memory killer in non-privileged container
    sed -i 's/OOMScoreAdjust/#OOMScoreAdjust/' /usr/lib/systemd/system/*.service

    # Execute kickstart scripts, if any, before systemd is started to make final adjustments.
    # NOTE: For one time scripts, which are must be ran once at start of the system,
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


To shutdown container, attach to container and shutdown your services (systemctl stop ...), then kill container.

Output of "ps ax" command in container:

    [root@74e84fff0fec /]# ps ax
      PID TTY      STAT   TIME COMMAND
        1 ?        Ss     0:00 /usr/lib/systemd/systemd
       69 ?        Ss     0:00 /usr/lib/systemd/systemd-journald
      146 ?        S      0:00 bash
      164 ?        R+     0:00 ps ax

Output of "journalctrl -xe: in container:

    -- Logs begin at Wed 2015-04-22 21:41:11 UTC, end at Wed 2015-04-22 21:44:23 UTC. --
    Apr 22 21:41:11 74e84fff0fec systemd-journal[69]: Runtime journal is using 8.0M (max 4.0G, leaving 4.0G of free 35.1G, current limit 4.0G).
    Apr 22 21:41:11 74e84fff0fec systemd-journal[69]: Runtime journal is using 8.0M (max 4.0G, leaving 4.0G of free 35.1G, current limit 4.0G).
    Apr 22 21:41:11 74e84fff0fec systemd-journal[69]: Journal started
    -- Subject: The Journal has been started
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- The system journal process has been starting up, opened the journal
    -- files for writing and is now ready to process requests.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Started Set Up Additional Binary Formats.
    -- Subject: Unit systemd-binfmt.service has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit systemd-binfmt.service has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Root Slice.
    -- Subject: Unit -.slice has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit -.slice has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Created slice Root Slice.
    -- Subject: Unit -.slice has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit -.slice has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting System Slice.
    -- Subject: Unit system.slice has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit system.slice has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Created slice System Slice.
    -- Subject: Unit system.slice has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit system.slice has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Slices.
    -- Subject: Unit slices.target has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit slices.target has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Reached target Slices.
    -- Subject: Unit slices.target has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit slices.target has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Swap.
    -- Subject: Unit swap.target has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit swap.target has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Reached target Swap.
    -- Subject: Unit swap.target has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit swap.target has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Local File Systems.
    -- Subject: Unit local-fs.target has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit local-fs.target has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Reached target Local File Systems.
    -- Subject: Unit local-fs.target has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit local-fs.target has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Create Volatile Files and Directories...
    -- Subject: Unit systemd-tmpfiles-setup.service has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit systemd-tmpfiles-setup.service has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Trigger Flushing of Journal to Persistent Storage...
    -- Subject: Unit systemd-journal-flush.service has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit systemd-journal-flush.service has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd-journal[69]: Runtime journal is using 8.0M (max 4.0G, leaving 4.0G of free 35.1G, current limit 4.0G).
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Started Create Volatile Files and Directories.
    -- Subject: Unit systemd-tmpfiles-setup.service has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit systemd-tmpfiles-setup.service has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Started Trigger Flushing of Journal to Persistent Storage.
    -- Subject: Unit systemd-journal-flush.service has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit systemd-journal-flush.service has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting System Initialization.
    -- Subject: Unit sysinit.target has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit sysinit.target has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Reached target System Initialization.
    -- Subject: Unit sysinit.target has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit sysinit.target has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Basic System.
    -- Subject: Unit basic.target has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit basic.target has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Reached target Basic System.
    -- Subject: Unit basic.target has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit basic.target has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Started Console Getty.
    -- Subject: Unit console-getty.service has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit console-getty.service has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Login Prompts.
    -- Subject: Unit getty.target has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit getty.target has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Reached target Login Prompts.
    -- Subject: Unit getty.target has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit getty.target has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Starting Multi-User System.
    -- Subject: Unit multi-user.target has begun with start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit multi-user.target has begun starting up.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Reached target Multi-User System.
    -- Subject: Unit multi-user.target has finished start-up
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- Unit multi-user.target has finished starting up.
    -- 
    -- The start-up result is done.
    Apr 22 21:41:11 74e84fff0fec systemd[1]: Startup finished in 3d 4h 20min 48.113s (kernel) + 131ms (userspace) = 3d 4h 20min 48.244s.
    -- Subject: System start-up is now complete
    -- Defined-By: systemd
    -- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
    -- 
    -- All system services necessary queued for starting at boot have been
    -- successfully started. Note that this does not mean that the machine is
    -- now idle as services might still be busy with completing start-up.
    -- 
    -- Kernel start-up required 274848113199 microseconds.
    -- 
    -- Initial RAM disk start-up required INITRD_USEC microseconds.
    -- 
    -- Userspace start-up required 131324 microseconds.
