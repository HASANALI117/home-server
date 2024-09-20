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

**Copy and rename the starter bash aliases file**:

```bash
mv shared/config/bash_aliases.env.example shared/config/bash_aliases.env
```

## Docker Aliases

1. `dstop`: Stops a running Docker container.

   - **Usage**:

     ```bash
     dstop my_container
     ```

2. `dstopall`: Stops all running Docker containers.

   - **Usage**:

     ```bash
     dstopall
     ```

3. `drm`: Removes a stopped Docker container.

   - **Usage**:

     ```bash
     drm container_name
     ```

   - **Example**:

     ```bash
     drm my_container
     ```

4. `dprunevol`: Removes unused Docker volumes.

   - **Usage**:

     ```bash
     dprunevol
     ```

5. `dprunesys`: Removes all unused Docker data (volumes, networks, images).

   - **Usage**:

     ```bash
     dprunesys
     ```

6. `ddelimages`: Deletes all unused Docker images.

   - **Usage**:

     ```bash
     ddelimages
     ```

7. `derase`: Stops, removes containers, and prunes the system (Deletes everything!).

   - **Usage**:

     ```bash
     derase
     ```

8. `dprune`: Safely cleans up Docker (unused images, volumes, and system).

   - **Usage**:

     ```bash
     dprune
     ```

9. `dexec`: Executes a command inside a running container (interactive mode).

   - **Usage**:

     ```bash
     dexec container_name
     ```

   - **Example**:

     ```bash
     dexec my_container /bin/bash
     ```

10. `dps`: Shows all Docker processes.

- **Usage**:

  ```bash
  dps
  ```

11. `dpss`: Shows Docker processes in a formatted table.

- **Usage**:

  ```bash
  dpss
  ```

12. `ddf`: Shows Docker data usage.

- **Usage**:

  ```bash
  ddf
  ```

13. `dlogs`: Shows the latest 50 logs of a container.

- **Usage**:

  ```bash
  dlogs container_name
  ```

14. `dlogsize`: Displays the size of Docker container logs.

- **Usage**:

  ```bash
  dlogsize
  ```

15. `dips`: Shows IP addresses of Docker containers.

- **Usage**:

  ```bash
  dips
  ```

16. `dp600`: Locks down the permissions for `$SECRETS` and `$ENV_FILE`.

- **Usage**:

  ```bash
  dp600
  ```

17. `dp777`: Opens permissions for `$SECRETS` and `$ENV_FILE` for editing.

- **Usage**:

  ```bash
  dp777
  ```

### **Docker Compose Aliases**

1. `dcrun`: Runs Docker Compose with the appropriate file.

   - **Usage**:

     ```bash
     dcrun
     ```

2. `dclogs`: Displays the logs for Docker Compose containers.

   - **Usage**:

     ```bash
     dclogs
     ```

3. `dcup`: Starts Docker Compose services and builds missing images.

   - **Usage**:

     ```bash
     dcup
     ```

4. `dcdown`: Stops and removes Docker Compose services.

   - **Usage**:

     ```bash
     dcdown
     ```

5. `dcrec`: Recreates Docker Compose containers.

   - **Usage**:

     ```bash
     dcrec container_name
     ```

6. `dcstop`: Stops Docker Compose services.

   - **Usage**:

     ```bash
     dcstop
     ```

7. `dcrestart`: Restarts Docker Compose services.

   - **Usage**:

     ```bash
     dcrestart
     ```

8. `dcstart`: Starts stopped Docker Compose services.

   - **Usage**:

     ```bash
     dcstart
     ```

9. `dcpull`: Pulls the latest images for services defined in Docker Compose.

   - **Usage**:

     ```bash
     dcpull
     ```

---

### **Docker Compose Profile Aliases**

#### **Manage "core" services** as defined by profiles in Docker Compose:

10. `startcore`: Starts the "core" services.

    - **Usage**:

      ```bash
      startcore
      ```

11. `createcore`: Builds and starts "core" services (removing orphaned containers).

    - **Usage**:

      ```bash
      createcore
      ```

12. `stopcore`: Stops the "core" services.

    - **Usage**:

      ```bash
      stopcore
      ```

#### **Manage "media" services** as defined by profiles in Docker Compose:

13. `stopmedia`: Stops the "media" services.

    - **Usage**:

      ```bash
      stopmedia
      ```

14. `createmedia`: Builds and starts "media" services (removing orphaned containers).

    - **Usage**:

      ```bash
      createmedia
      ```

15. `startmedia`: Starts the "media" services.

    - **Usage**:

      ```bash
      startmedia
      ```

#### **Manage "downloads" services** as defined by profiles in Docker Compose:

16. `stopdownloads`: Stops the "downloads" services.

    - **Usage**:

      ```bash
      stopdownloads
      ```

17. `createdownloads`: Builds and starts "downloads" services (removing orphaned containers).

    - **Usage**:

      ```bash
      createdownloads
      ```

18. `startdownloads`: Starts the "downloads" services.

    - **Usage**:

      ```bash
      startdownloads
      ```

#### **Manage Starr apps** as defined by profiles in Docker Compose:

19. `stoparrs`: Stops the Starr apps services.

    - **Usage**:

      ```bash
      stoparrs
      ```

20. `createarrs`: Builds and starts the Starr apps services (removing orphaned containers).

    - **Usage**:

      ```bash
      createarrs
      ```

21. `startarrs`: Starts the Starr apps services.

    - **Usage**:

      ```bash
      startarrs
      ```

#### **Manage "dbs" (database) services** as defined by profiles in Docker Compose:

22. `stopdbs`: Stops the database services.

    - **Usage**:

      ```bash
      stopdbs
      ```

23. `createdbs`: Builds and starts the database services (removing orphaned containers).

    - **Usage**:

      ```bash
      createdbs
      ```

24. `startdbs`: Starts the database services.

    - **Usage**:

      ```bash
      startdbs
      ```

### **CrowdSec Aliases**

1. `cscli`: Executes CrowdSec CLI commands.

   - **Usage**:

     ```bash
     cscli
     ```

2. `csdecisions`: Lists current CrowdSec decisions.

   - **Usage**:

     ```bash
     csdecisions
     ```

3. `csalerts`: Displays CrowdSec alerts.

   - **Usage**:

     ```bash
     csalerts
     ```

4. `csinspect`: Inspect CrowdSec alerts in detail.

   - **Usage**:

     ```bash
     csinspect
     ```

5. `cshubs`: Lists available CrowdSec hub resources.

   - **Usage**:

     ```bash
     cshubs
     ```

6. `csparsers`: Lists available CrowdSec parsers.

   - **Usage**:

     ```bash
     csparsers
     ```

7. `cscollections`: Lists CrowdSec collections.

   - **Usage**:

     ```bash
     cscollections
     ```

8. `cshubupdate`: Updates CrowdSec hub resources.

   - **Usage**:

     ```bash
     cshubupdate
     ```

9. `cshubupgrade`: Upgrades CrowdSec hub resources.

   - **Usage**:

     ```bash
     cshubupgrade
     ```

10. `csmetrics`: Displays CrowdSec metrics.

    - **Usage**:

      ```bash
      csmetrics
      ```

11. `csmachines`: Lists CrowdSec registered machines.

    - **Usage**:

      ```bash
      csmachines
      ```

12. `csbouncers`: Lists CrowdSec registered bouncers.

    - **Usage**:

      ```bash
      csbouncers
      ```

13. `csfbstatus`: Shows the status of the CrowdSec firewall bouncer service.

    - **Usage**:

      ```bash
      csfbstatus
      ```

14. `csfbstart`: Starts the CrowdSec firewall bouncer service.

    - **Usage**:

      ```bash
      csfbstart
      ```

15. `csfbstop`: Stops the CrowdSec firewall bouncer service.

    - **Usage**:

      ```bash
      csfbstop
      ```

16. `csfbrestart`: Restarts the CrowdSec firewall bouncer service.

    - **Usage**:

      ```bash
      csfbrestart
      ```

17. `tailkern`: Tails the kernel log file.

    - **Usage**:

      ```bash
      tailkern
      ```

18. `tailauth`: Tails the authentication log file.

    - **Usage**:

      ```bash
      tailauth
      ```

19. `tailcsfb`: Tails the CrowdSec firewall bouncer log file.

    - **Usage**:

      ```bash
      tailcsfb
      ```

20. `csbrestart`: Restarts both Traefik bouncer and CrowdSec firewall bouncer.

    - **Usage**:

      ```bash
      csbrestart
      ```

### **Web Stack Aliases**

1. `webrs`: Recreates the web stack services (PHP 7, Redis, Nginx).

   - **Usage**:

     ```bash
     webrs
     ```

### **Docker Traefik 1 Swarm Aliases**

1. `dslogs`: Shows the logs of the Docker service in real-time, tailing the last 50 entries.

   - **Usage**:

     ```bash
     dslogs
     ```

2. `dsps`: Displays the processes running in the `zstack` Docker Swarm stack.

   - **Usage**:

     ```bash
     dsps
     ```

3. `dsse`: Lists the services in the `zstack` Docker Swarm stack.

   - **Usage**:

     ```bash
     dsse
     ```

4. `dsls`: Lists all Docker Swarm stacks.

   - **Usage**:

     ```bash
     dsls
     ```

5. `dsrm`: Removes a Docker Swarm stack.

   - **Usage**:

     ```bash
     dsrm stack_name
     ```

6. `dsup`: Deploys the `zstack` Docker Swarm stack using the specified Compose file.

   - **Usage**:

     ```bash
     dsup
     ```

7. `dshelp`: Displays a quick list of all Docker Swarm-related commands.

   - **Usage**:

     ```bash
     dshelp
     ```

### **File Compression Aliases**

1. `untargz`: Extracts a `.tar.gz` file.

   - **Usage**:

     ```bash
     untargz archive.tar.gz
     ```

2. `untarbz`: Extracts a `.tar.bz` file.

   - **Usage**:

     ```bash
     untarbz archive.tar.bz
     ```

3. `lstargz`: Lists contents of a `.tar.gz` archive.

   - **Usage**:

     ```bash
     lstargz archive.tar.gz
     ```

4. `lstarbz`: Lists contents of a `.tar.bz` archive.

   - **Usage**:

     ```bash
     lstarbz archive.tar.bz
     ```

5. `targz`: Compresses files into a `.tar.gz` archive.

   - **Usage**:

     ```bash
     targz archive_name.tar.gz directory_or_file
     ```

6. `tarbz`: Compresses files into a `.tar.bz` archive.

   - **Usage**:

     ```bash
     tarbz archive_name.tar.bz directory_or_file
     ```

### **File Navigation Aliases**

35. `cd..`: Moves up one directory.

    - **Usage**:

    ```bash
    cd..
    ```

36. `..`: Moves up one directory (alternative shortcut).

    - **Usage**:

    ```bash
    ..
    ```

37. `...`: Moves up two directories.

    - **Usage**:

    ```bash
    ...
    ```

38. `.3`: Moves up three directories.

    - **Usage**:

    ```bash
    .3
    ```

39. `.4`: Moves up four directories.

    - **Usage**:

    ```bash
    .4
    ```

40. `.5`: Moves up five directories.

    - **Usage**:

    ```bash
    .5
    ```

### **Sync and Copy Aliases**

1. `scp`: Copies files and directories recursively using `scp`.

   - **Usage**:

     ```bash
     scp source destination
     ```

2. `rsynce`: Executes `rsync` with progress, force, delete, and an exclude list.

   - **Usage**:

     ```bash
     rsynce source destination
     ```

3. `rsyncne`: Executes `rsync` with progress, force, and delete.

   - **Usage**:

     ```bash
     rsyncne source destination
     ```

4. `cpn`: Native copy with verbose output.

   - **Usage**:

     ```bash
     cpn source destination
     ```

5. `cp`: Copies files using `rsync` with progress.

   - **Usage**:

     ```bash
     cp source destination
     ```

6. `mv`: Moves files using `rsync` and removes the source files.

   - **Usage**:

     ```bash
     mv source destination
     ```

7. `mvn`: Native move with verbose output.

   - **Usage**:

     ```bash
     mvn source destination
     ```

---

### **Search and Find Aliases**

1. `gh`: Searches your Bash history using `grep`.

   - **Usage**:

     ```bash
     gh keyword
     ```

2. `findr`: Finds files or directories by name.

   - **Usage**:

     ```bash
     findr filename
     ```

3. `grep`, `egrep`, `fgrep`: Grep commands with color-enabled output.

   - **Usage**:

     ```bash
     grep pattern file
     egrep pattern file
     fgrep pattern file
     ```

---

### **Trash Aliases (Using trash-cli)**

1. `rm`: Moves files to trash instead of permanently deleting.

   - **Usage**:

     ```bash
     rm file
     ```

2. `rmv`: Deletes files with verbose output.

   - **Usage**:

     ```bash
     rmv file
     ```

3. `tempty`: Empties the trash.

   - **Usage**:

     ```bash
     tempty
     ```

4. `tlist`: Lists items in the trash.

   - **Usage**:

     ```bash
     tlist
     ```

5. `srmt`: Deletes files with sudo privileges using trash.

   - **Usage**:

     ```bash
     srmt file
     ```

---

### **File Size and Storage Aliases**

1. `fdisk`: Lists disk partitions and sizes.

   - **Usage**:

     ```bash
     fdisk
     ```

2. `uuid`: Retrieves the UUID of a volume.

   - **Usage**:

     ```bash
     uuid /dev/sda1
     ```

3. `ls`: Lists directory contents with color and sorting directories first.

   - **Usage**:

     ```bash
     ls
     ```

4. `ll`: Lists all files in a detailed format with human-readable file sizes.

   - **Usage**:

     ```bash
     ll
     ```

5. `lt`: Lists files sorted by size.

   - **Usage**:

     ```bash
     lt
     ```

6. `lsr`: Lists files sorted by recently modified.

   - **Usage**:

     ```bash
     lsr
     ```

7. `mnt`: Lists mounted drives.

   - **Usage**:

     ```bash
     mnt
     ```

8. `dirsize`: Shows the size of directories.

   - **Usage**:

     ```bash
     dirsize
     ```

9. `dirusage`: Shows the disk usage of the current directory.

   - **Usage**:

     ```bash
     dirusage
     ```

10. `diskusage`: Shows total disk usage.

- **Usage**:

  ```bash
  diskusage
  ```

11. `partusage`: Shows partition usages excluding temporary memory.

- **Usage**:

  ```bash
  partusage
  ```

12. `usage10`: Shows the top 10 items using the most space in the current directory.

- **Usage**:

  ```bash
  usage10
  ```

---

### **Bash Aliases**

1. `baupdate`: Reloads your Bash configuration.

   - **Usage**:

     ```bash
     baupdate
     ```

2. `baedit`: Opens your Bash aliases file for editing.

   - **Usage**:

     ```bash
     baedit
     ```

3. `bacopy`: Copies your Bash aliases to the root directory.

   - **Usage**:

     ```bash
     bacopy
     ```

4. `baget`: Downloads the latest Bash aliases from the internet.

   - **Usage**:

     ```bash
     baget
     ```

---

### **Git and Site Management Aliases**

1. `gcpush`: Pushes changes to the Docker-Traefik repository.

   - **Usage**:

     ```bash
     gcpush ../commits/date.txt
     ```

2. `gpush`: Pushes changes to your Git repository.

   - **Usage**:

     ```bash
     gpush
     ```

3. `ggraph`: Displays a visual Git log graph.

   - **Usage**:

     ```bash
     ggraph
     ```

---

### **Mail Server Testing Aliases**

1. `nullsend`: Sends a null mail to trigger the mail server.

   - **Usage**:

     ```bash
     nullsend
     ```

2. `tmail1`: Sends a test email from `tmail1`.

   - **Usage**:

     ```bash
     tmail1
     ```

3. `tmail2`: Sends a test email from `tmail2` with a provided email address.

   - **Usage**:

     ```bash
     tmail2 email@example.com
     ```

---

### **UFW Firewall Aliases**

1. `ufwenable`: Enables the UFW firewall.

   - **Usage**:

     ```bash
     ufwenable
     ```

2. `ufwdisable`: Disables the UFW firewall.

   - **Usage**:

     ```bash
     ufwdisable
     ```

3. `ufwallow`: Allows a service or port through the firewall.

   - **Usage**:

     ```bash
     ufwallow service_name_or_port
     ```

4. `ufwlimit`: Limits access to a service or port.

   - **Usage**:

     ```bash
     ufwlimit service_name_or_port
     ```

5. `ufwlist`: Lists firewall rules with numbered entries.

   - **Usage**:

     ```bash
     ufwlist
     ```

6. `ufwdelete`: Deletes a firewall rule.

   - **Usage**:

     ```bash
     ufwdelete rule_number
     ```

7. `ufwreload`: Reloads the firewall settings.

   - **Usage**:

     ```bash
     ufwreload
     ```

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
