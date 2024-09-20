# Bash Aliases & Shortcuts

This file contains useful bash aliases for various system, Docker, Docker Compose, firewall, file management, and systemd tasks. These aliases can greatly improve workflow efficiency by providing shorthand commands.

## Setup

1. Ensure that your configuration file includes:

   ```bash
   source "$HOME/.config.env"
   ```

2. Copy and rename the starter bash aliases file:

   ```bash
   mv shared/config/bash_aliases.env.example shared/config/bash_aliases.env
   ```

3. Load environmental variables for bash aliases:

   ```bash
   if [[ -f "$SHARED/config/bash_aliases.env" ]]; then
     source $SHARED/config/bash_aliases.env
   fi
   ```

4. Customize the bash prompt:

   ```bash
   export PS1='[\e[0;32m\u\e[0m@\e[0;33m\H\e[0m: \e[0;36m\w\e[0m]\$ '
   ```

## Docker Aliases

### Stopping Containers

- `dstop [container_name]`: Stops a specific container.

  Example:

  ```bash
  dstop my_container
  ```

- `dstopall`: Stops all running containers.

  Example:

  ```bash
  dstopall
  ```

### Removing Containers

- `drm [container_name]`: Removes a specific container.

  Example:

  ```bash
  drm my_container
  ```

### Docker Clean-Up

- `dprunevol`: Removes unused volumes.

  Example:

  ```bash
  dprunevol
  ```

- `dprunesys`: Removes unused Docker data.

  Example:

  ```bash
  dprunesys
  ```

- `ddelimages`: Deletes all unused Docker images.

  Example:

  ```bash
  ddelimages
  ```

- `dprune`: Executes a safe Docker system cleanup.

  Example:

  ```bash
  dprune
  ```

- `derase`: Removes all containers, volumes, and images (use with caution).

  Example:

  ```bash
  derase
  ```

### Docker Logs

- `dlogs [container_name]`: Tails the last 50 lines of logs for a specific container.

  Example:

  ```bash
  dlogs my_container
  ```

- `dlogsize`: Displays the size of log files for all Docker containers.

  Example:

  ```bash
  dlogsize
  ```

### Docker Compose

- `dcup`: Starts all services defined in the Docker Compose file with building and orphan removal.

  Example:

  ```bash
  dcup
  ```

- `dcdown`: Stops all services and removes the containers.

  Example:

  ```bash
  dcdown
  ```

- `dcrestart [service_name]`: Restarts a specific service.

  Example:

  ```bash
  dcrestart my_service
  ```

- `dcpull [service_name]`: Pulls the latest images for all services or a specific service.

  Example:

  ```bash
  dcpull my_service
  ```

## File Management

### Copy and Move Files

- `cp [source] [destination]`: Copy files using `rsync`.

  Example:

  ```bash
  cp /path/to/source /path/to/destination
  ```

- `mv [source] [destination]`: Move files using `rsync` with source file deletion.

  Example:

  ```bash
  mv /path/to/source /path/to/destination
  ```

- `rsynce [source] [destination]`: Sync directories using `rsync` with exclusions from a configuration file.

  Example:

  ```bash
  rsynce /source/dir /destination/dir
  ```

### Trash Management

- `rm [file]`: Move a file to trash using `trash-put`.

  Example:

  ```bash
  rm myfile.txt
  ```

- `tempty`: Empty the trash.

  Example:

  ```bash
  tempty
  ```

- `tlist`: List all files in trash.

  Example:

  ```bash
  tlist
  ```

## System Management

### System Update & Clean-Up

- `update`: Update package information from all configured sources.

  Example:

  ```bash
  update
  ```

- `upgrade`: Upgrade all installed packages.

  Example:

  ```bash
  upgrade
  ```

- `clean`: Cleans up package manager's cache and removes unused packages.

  Example:

  ```bash
  clean
  ```

### Systemd Service Management

- `ctlstart [service_name]`: Start a systemd service.

  Example:

  ```bash
  ctlstart nginx
  ```

- `ctlstop [service_name]`: Stop a systemd service.

  Example:

  ```bash
  ctlstop nginx
  ```

- `ctlstatus [service_name]`: Check the status of a systemd service.

  Example:

  ```bash
  ctlstatus nginx
  ```

### Firewall (UFW)

- `ufwenable`: Enable UFW (Uncomplicated Firewall).

  Example:

  ```bash
  ufwenable
  ```

- `ufwlist`: List all active UFW rules.

  Example:

  ```bash
  ufwlist
  ```

- `ufwdelete [rule_number]`: Delete a specific UFW rule by its number.

  Example:

  ```bash
  ufwdelete 1
  ```

## File Size & Disk Usage

- `diskusage`: Displays total disk usage on your system.

  Example:

  ```bash
  diskusage
  ```

- `usage10`: Lists the top 10 largest files and directories in the current directory.

  Example:

  ```bash
  usage10
  ```

- `dirsize [directory]`: Shows the size of each directory within the specified path.

  Example:

  ```bash
  dirsize /path/to/directory
  ```

## Navigation Shortcuts

- `..`, `...`, `.3`, `.4`, `.5`: Navigate quickly through multiple parent directories.

  Example:

  ```bash
  ..
  ```

  ```bash
  .4
  ```

## Git Aliases

- `gpush`: Push changes to the remote Git repository.

  Example:

  ```bash
  gpush
  ```

- `ggraph`: Display the Git commit history graph.

  Example:

  ```bash
  ggraph
  ```

## Networking

- `portsused`: List all open ports.

  Example:

  ```bash
  portsused
  ```

- `showlistening`: Show all active network services.

  Example:

  ```bash
  showlistening
  ```

- `ipe`: Get the external IP address of the machine.

  Example:

  ```bash
  ipe
  ```

## Monitoring and System Info

- `meminfo`: Displays detailed memory usage.

  Example:

  ```bash
  meminfo
  ```

- `psmem10`: Shows the top 10 processes consuming the most memory.

  Example:

  ```bash
  psmem10
  ```

- `pscpu10`: Shows the top 10 processes consuming the most CPU.

  Example:

  ```bash
  pscpu10
  ```

---

These aliases are designed to optimize workflow and system management, making it easier to perform complex tasks with simple commands.
