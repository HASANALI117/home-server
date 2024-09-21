# Bash Aliases & Shortcuts

## **Table of Contents**

1. [Docker Aliases](#docker-aliases)
2. [Docker Compose Aliases](#docker-compose-aliases)
3. [Docker Compose Profile Aliases](#docker-compose-profile-aliases)
4. [CrowdSec Aliases](#crowdsec-aliases)
5. [Web Stack Aliases](#web-stack-aliases)
6. [Docker Traefik 1 Swarm Aliases](#docker-traefik-1-swarm-aliases)
7. [File Compression Aliases](#file-compression-aliases)
8. [File Navigation Aliases](#file-navigation-aliases)
9. [Sync and Copy Aliases](#sync-and-copy-aliases)
10. [Search and Find Aliases](#search-and-find-aliases)
11. [Trash Aliases](#trash-aliases)
12. [File Size and Storage Aliases](#file-size-and-storage-aliases)
13. [Bash Aliases](#bash-aliases)
14. [Git and Site Management Aliases](#git-and-site-management-aliases)
15. [Mail Server Testing Aliases](#mail-server-testing-aliases)
16. [UFW Firewall Aliases](#ufw-firewall-aliases)
17. [Systemd Start, Stop, and Restart Aliases](#systemd-start-stop-and-restart-aliases)
18. [Installation and Upgrade Aliases](#installation-and-upgrade-aliases)
19. [Cleaning Aliases](#cleaning-aliases)
20. [Shutdown and Restart Aliases](#shutdown-and-restart-aliases)
21. [Networking Aliases](#networking-aliases)
22. [Synology DSM Commands](#synology-dsm-commands)
23. [Miscellaneous Aliases](#miscellaneous-aliases)
24. [System Monitoring Aliases](#system-monitoring-aliases)
25. [Rclone Aliases](#rclone-aliases)
26. [YouTube-DLP Aliases](#youtube-dlp-aliases)
27. [Auto-Traefik Aliases](#auto-traefik-aliases)
28. [Pi-Hole Aliases](#pi-hole-aliases)
29. [VNC Aliases](#vnc-aliases)

---

## Setup

**Fill in the environment variables in the bash aliases file**:

The script already copies the `bash_aliases.env.example` file to `$SHARED/config/bash_aliases.env`. You just need to fill in the environment variables in `$SHARED/config/bash_aliases.env`.

```bash
nano $SHARED/config/bash_aliases.env
```

---

## Docker Aliases

- `dstop`: Stops a running Docker container.

  - **Usage**:

    ```bash
    dstop my_container
    ```

- `dstopall`: Stops all running Docker containers.

- `drm`: Removes a stopped Docker container.

  - **Usage**:

    ```bash
    drm container_name
    ```

- `dprunevol`: Removes unused Docker volumes.

- `dprunesys`: Removes all unused Docker data (volumes, networks, images).

- `ddelimages`: Deletes all unused Docker images.

- `derase`: Stops, removes containers, and prunes the system (Deletes everything!).

- `dprune`: Safely cleans up Docker (unused images, volumes, and system).

- `dexec`: Executes a command inside a running container (interactive mode).

  - **Example**:

    ```bash
    dexec my_container /bin/bash
    ```

- `dps`: Shows all Docker processes.

- `dpss`: Shows Docker processes in a formatted table.

- `ddf`: Shows Docker data usage.

- `dlogs`: Shows the latest 50 logs of a container.

  - **Usage**:

    ```bash
    dlogs container_name
    ```

- `dlogsize`: Displays the size of Docker container logs.

- `dips`: Shows IP addresses of Docker containers.

- `dp600`: Locks down the permissions for `$SECRETS` and `$ENV_FILE`.

- `dp777`: Opens permissions for `$SECRETS` and `$ENV_FILE` for editing.

---

### **Docker Compose Aliases**

- `dcrun`: Runs Docker Compose with the appropriate file.

- `dclogs`: Displays the logs for Docker Compose containers.

- `dcup`: Starts Docker Compose services and builds missing images.

- `dcdown`: Stops and removes Docker Compose services.

- `dcrec`: Recreates Docker Compose containers.

  - **Usage**:

    ```bash
    dcrec container_name
    ```

- `dcstop`: Stops Docker Compose services.

- `dcrestart`: Restarts Docker Compose services.

- `dcstart`: Starts stopped Docker Compose services.

- `dcpull`: Pulls the latest images for services defined in Docker Compose.

---

### **Docker Compose Profile Aliases**

#### **Manage "core" services** as defined by profiles in Docker Compose:

- `startcore`: Starts the "core" services.

- `createcore`: Builds and starts "core" services (removing orphaned containers).

- `stopcore`: Stops the "core" services.

#### **Manage "media" services** as defined by profiles in Docker Compose:

- `stopmedia`: Stops the "media" services.

- `createmedia`: Builds and starts "media" services (removing orphaned containers).

- `startmedia`: Starts the "media" services.

#### **Manage "downloads" services** as defined by profiles in Docker Compose:

- `stopdownloads`: Stops the "downloads" services.

- `createdownloads`: Builds and starts "downloads" services (removing orphaned containers).

- `startdownloads`: Starts the "downloads" services.

#### **Manage Starr apps** as defined by profiles in Docker Compose:

- `stoparrs`: Stops the Starr apps services.

- `createarrs`: Builds and starts the Starr apps services (removing orphaned containers).

- `startarrs`: Starts the Starr apps services.

#### **Manage "dbs" (database) services** as defined by profiles in Docker Compose:

- `stopdbs`: Stops the database services.

- `createdbs`: Builds and starts the database services (removing orphaned containers).

- `startdbs`: Starts the database services.

---

### **CrowdSec Aliases**

- `cscli`: Executes CrowdSec CLI commands.

- `csdecisions`: Lists current CrowdSec decisions.

- `csalerts`: Displays CrowdSec alerts.

- `csinspect`: Inspect CrowdSec alerts in detail.

- `cshubs`: Lists available CrowdSec hub resources.

- `csparsers`: Lists available CrowdSec parsers.

- `cscollections`: Lists CrowdSec collections.

- `cshubupdate`: Updates CrowdSec hub resources.

- `cshubupgrade`: Upgrades CrowdSec hub resources.

- `csmetrics`: Displays CrowdSec metrics.

- `csmachines`: Lists CrowdSec registered machines.

- `csbouncers`: Lists CrowdSec registered bouncers.

- `csfbstatus`: Shows the status of the CrowdSec firewall bouncer service.

- `csfbstart`: Starts the CrowdSec firewall bouncer service.

- `csfbstop`: Stops the CrowdSec firewall bouncer service.

- `csfbrestart`: Restarts the CrowdSec firewall bouncer service.

- `tailkern`: Tails the kernel log file.

- `tailauth`: Tails the authentication log file.

- `tailcsfb`: Tails the CrowdSec firewall bouncer log file.

- `csbrestart`: Restarts both Traefik bouncer and CrowdSec firewall bouncer.

---

### **Web Stack Aliases**

- `webrs`: Recreates the web stack services (PHP 7, Redis, Nginx).

---

### **Docker Traefik 1 Swarm Aliases**

- `dslogs`: Shows the logs of the Docker service in real-time, tailing the last 50 entries.

- `dsps`: Displays the processes running in the `zstack` Docker Swarm stack.

- `dsse`: Lists the services in the `zstack` Docker Swarm stack.

- `dsls`: Lists all Docker Swarm stacks.

- `dsrm`: Removes a Docker Swarm stack.

  - **Usage**:

    ```bash
    dsrm stack_name
    ```

- `dsup`: Deploys the `zstack` Docker Swarm stack using the specified Compose file.

- `dshelp`: Displays a quick list of all Docker Swarm-related commands.

---

### **File Compression Aliases**

- `untargz`: Extracts a `.tar.gz` file.

  - **Usage**:

    ```bash
    untargz archive.tar.gz
    ```

- `untarbz`: Extracts a `.tar.bz` file.

  - **Usage**:

    ```bash
    untarbz archive.tar.bz
    ```

- `lstargz`: Lists contents of a `.tar.gz` archive.

  - **Usage**:

    ```bash
    lstargz archive.tar.gz
    ```

- `lstarbz`: Lists contents of a `.tar.bz` archive.

  - **Usage**:

    ```bash
    lstarbz archive.tar.bz
    ```

- `targz`: Compresses files into a `.tar.gz` archive.

  - **Usage**:

    ```bash
    targz archive_name.tar.gz directory_or_file
    ```

- `tarbz`: Compresses files into a `.tar.bz` archive.

  - **Usage**:

    ```bash
    tarbz archive_name.tar.bz directory_or_file
    ```

---

### **File Navigation Aliases**

- `cd..`: Moves up one directory.

- `..`: Moves up one directory (alternative shortcut).

- `...`: Moves up two directories.

- `.3`: Moves up three directories.

- `.4`: Moves up four directories.

- `.5`: Moves up five directories.

---

### **Sync and Copy Aliases**

- `scp`: Copies files and directories recursively using `scp`.

  - **Usage**:

    ```bash
    scp source destination
    ```

- `rsynce`: Executes `rsync` with progress, force, delete, and an exclude list.

  - **Usage**:

    ```bash
    rsynce source destination
    ```

- `rsyncne`: Executes `rsync` with progress, force, and delete.

  - **Usage**:

    ```bash
    rsyncne source destination
    ```

- `cpn`: Native copy with verbose output.

  - **Usage**:

    ```bash
    cpn source destination
    ```

- `cp`: Copies files using `rsync` with progress.

  - **Usage**:

    ```bash
    cp source destination
    ```

- `mv`: Moves files using `rsync` and removes the source files.

  - **Usage**:

    ```bash
    mv source destination
    ```

- `mvn`: Native move with verbose output.

  - **Usage**:

    ```bash
    mvn source destination
    ```

---

### **Search and Find Aliases**

- `gh`: Searches your Bash history using `grep`.

  - **Usage**:

    ```bash
    gh keyword
    ```

- `findr`: Finds files or directories by name.

  - **Usage**:

    ```bash
    findr filename
    ```

- `grep`, `egrep`, `fgrep`: Grep commands with color-enabled output.

  - **Usage**:

    ```bash
    grep pattern file
    egrep pattern file
    fgrep pattern file
    ```

---

### **Trash Aliases (Using trash-cli)**

- `rm`: Moves files to trash instead of permanently deleting.

  - **Usage**:

    ```bash
    rm file
    ```

- `rmv`: Deletes files with verbose output.

  - **Usage**:

    ```bash
    rmv file
    ```

- `tempty`: Empties the trash.

- `tlist`: Lists items in the trash.

- `srmt`: Deletes files with sudo privileges using trash.

  - **Usage**:

    ```bash
    srmt file
    ```

---

### **File Size and Storage Aliases**

- `fdisk`: Lists disk partitions and sizes.

- `uuid`: Retrieves the UUID of a volume.

  - **Usage**:

    ```bash
    uuid /dev/sda1
    ```

- `ls`: Lists directory contents with color and sorting directories first.

- `ll`: Lists all files in a detailed format with human-readable file sizes.

- `lt`: Lists files sorted by size.

- `lsr`: Lists files sorted by recently modified.

- `mnt`: Lists mounted drives.

- `dirsize`: Shows the size of directories.

- `dirusage`: Shows the disk usage of the current directory.

- `diskusage`: Shows total disk usage.

- `partusage`: Shows partition usages excluding temporary memory.

- `usage10`: Shows the top 10 items using the most space in the current directory.

---

### **Bash Aliases**

- `baupdate`: Reloads your Bash configuration.

- `baedit`: Opens your Bash aliases file for editing.

- `bacopy`: Copies your Bash aliases to the root directory.

- `baget`: Downloads the latest Bash aliases from the internet.

---

### **Git and Site Management Aliases**

- `gcpush`: Pushes changes to the Docker-Traefik repository.

  - **Usage**:

    ```bash
    gcpush ../commits/date.txt
    ```

- `gpush`: Pushes changes to your Git repository.

- `ggraph`: Displays a visual Git log graph.

---

### **Mail Server Testing Aliases**

- `nullsend`: Sends a null mail to trigger the mail server.

- `tmail1`: Sends a test email from `tmail1`.

- `tmail2`: Sends a test email from `tmail2` with a provided email address.

  - **Usage**:

    ```bash
    tmail2 email@example.com
    ```

---

### **UFW Firewall Aliases**

- `ufwenable`: Enables the UFW firewall.

- `ufwdisable`: Disables the UFW firewall.

- `ufwallow`: Allows a service or port through the firewall.

  - **Usage**:

    ```bash
    ufwallow service_name_or_port
    ```

- `ufwlimit`: Limits access to a service or port.

  - **Usage**:

    ```bash
    ufwlimit service_name_or_port
    ```

- `ufwlist`: Lists firewall rules with numbered entries.

- `ufwdelete`: Deletes a firewall rule.

  - **Usage**:

    ```bash
    ufwdelete rule_number
    ```

- `ufwreload`: Reloads the firewall settings.

---

### **Systemd Start, Stop, and Restart Aliases**

1. **Systemctl Aliases**:

   - `ctlreload`: Reloads systemd daemon.
   - `ctlstart`: Starts a systemd service.
   - `ctlstop`: Stops a systemd service.
   - `ctlrestart`: Restarts a systemd service.
   - `ctlstatus`: Shows the status of a systemd service.
   - `ctlenable`: Enables a systemd service at boot.
   - `ctldisable`: Disables a systemd service at boot.
   - `ctlactive`: Checks if a systemd service is active.

   - **Usage**:

     ```bash
     ctlstart service_name
     ctlstop service_name
     ```

2. **Service-specific Aliases**:

   - ShellInABox service management:

     - `shellstart`, `shellstop`, `shellrestart`, `shellstatus`

   - SSH service management:

     - `sshstart`, `sshstop`, `sshrestart`, `sshstatus`

   - UFW firewall management:

     - `ufwstart`, `ufwstop`, `ufwrestart`, `ufwstatus`

   - Webmin management:

     - `webminstart`, `webminstop`, `webminrestart`, `webminstatus`

   - Samba service management:

     - `sambastart`, `sambastop`, `sambarestart`, `sambastatus`

   - NFS service management:
     - `nfsstart`, `nfsstop`, `nfsrestart`, `nfsstatus`
     - `nfsreload`: Reloads NFS exports.

---

### **Installation and Upgrade Aliases**

- `update`: Runs `apt-get update`.
- `upgrade`: Updates and upgrades packages.
- `install`: Installs packages.
- `finstall`: Fixes broken package installations.
- `rinstall`: Reinstalls packages.
- `uninstall`: Removes packages.
- `search`: Searches for packages.
- `addkey`: Adds a GPG key to the system.

  - **Usage**:

    ```bash
    update
    install package_name
    ```

---

### **Cleaning Aliases**

- `clean`: Cleans the package cache.
- `remove`: Removes unused packages.
- `purge`: Purges packages.
- `deborphan`: Removes orphaned packages.
- `cleanall`: Runs all cleaning commands.

  - **Usage**:

    ```bash
    cleanall
    ```

---

### **Shutdown and Restart Aliases**

- `shutdown`: Shuts down the system immediately.
- `reboot`: Reboots the system.

  - **Usage**:

    ```bash
    shutdown
    reboot
    ```

---

### **Networking Aliases**

- `portsused`: Displays used ports.
- `showports`: Shows listening ports using `netstat`.
- `showlistening`: Displays active listening services using `lsof`.
- `ping`: Pings a host 5 times.
- `ipe`: Displays the external IP.
- `ipi`: Displays the internal IP.
- `header`: Fetches web server headers.

  - **Usage**:

    ```bash
    portsused
    ping example.com
    ```

---

### **Synology DSM Commands**

- `servicelist`: Lists services (DSM 6 only).
- `servicestatus`, `servicestop`, `servicestart`, `servicerestart`: Manage Synology system services.
- `servicehstop`, `servicehstart`: Hard stop/start services (DSM 6 only).
- `restartdocker`: Restarts Docker on Synology.

  - **Usage**:

    ```bash
    servicelist
    restartdocker
    ```

---

### **Miscellaneous Aliases**

- `wget`: Resumes downloads with `wget`.
- `nano`: Edits files using `nano` with syntax highlighting.
- `scxterm`: Starts an Xterm session.

  - **Usage**:

    ```bash
    wget url
    nano file
    ```

---

### **System Monitoring Aliases**

- `meminfo`: Displays memory usage.
- `psmem`, `psmem10`: Shows processes consuming the most memory.
- `pscpu`, `pscpu10`: Shows processes consuming the most CPU.
- `cpuinfo`: Displays CPU info.
- `gpumeminfo`: Displays GPU memory usage.
- `free`: Displays memory in human-readable format.

  - **Usage**:

    ```bash
    meminfo
    psmem10
    ```

---

### **Rclone Aliases**

- `rcdlogs`, `rcclogs`: Tail Rclone logs.
- `rcupmedia`, `rcupmedialogs`: Upload media to cloud.
- `rcupdump`, `rcupdumplogs`: Upload database dump.
- `rcrestart`, `rcstop`, `rcstart`: Manage Rclone service.
- `rcstatus`: Check Rclone status.
- `rcps`: List running Rclone processes.
- `rcupdate`: Update Rclone.
- `rcpurge`: Purge Rclone cache.
- `rcforget`: Forget Rclone VFS cache.

  - **Usage**:

    ```bash
    rcstart
    rcupdate
    ```

---

### **YouTube-DLP Aliases**

- `ytupdate`: Update `yt-dlp`.
- `ytlist`: List formats available for download.
- `ytdump`: Dump video information as JSON.
- `ytdv`, `ytdvc`: Download videos using config.
- `ytda`, `ytdac`: Download audio using config.

  - **Usage**:

    ```bash
    ytlist video_url
    ytda video_url
    ```

---

### **Auto-Traefik Aliases**

- `sshagent`: Starts the SSH agent and adds the GitHub key.
- `atpush`: Pushes changes to the Auto-Traefik Git repository.

  - **Usage**:

    ```bash
    atpush
    ```

---

### **Pi-Hole Aliases**

- `pidis`: Disables Pi-Hole.
- `pien`: Enables Pi-Hole.
- `pi10`: Temporarily disables Pi-Hole for 10 minutes.
- `piup`: Updates Pi-Hole.
- `rpi3up`, `rpi0up`: Updates Raspberry Pi systems.

  - **Usage**:

    ```bash
    pidis
    piup
    ```

---

### **VNC Aliases**

- `vnc1`: Starts a VNC server session with specific resolution.
- `vnckill1`: Kills the VNC session on display `:1`.

  - **Usage**:

    ```bash
    vnc1
    vnckill1
    ```

---

These aliases are designed to optimize workflow and system management, making it easier to perform complex tasks with simple commands.
