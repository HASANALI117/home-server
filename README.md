# Home Server Automation

This repository automates the setup and management of my home server using Docker and Docker Compose.

<p align="center">
  <img src="assets/docker-moby.png" alt="Docker" width="70" height="70">
  <img src="assets/portainer-alt.png" alt="Portainer" width="70" height="70">
  <img src="assets/homepage.png" alt="Homepage" width="70" height="70" style="border-radius: 100%;">
  <img src="assets/plex.png" alt="Plex" width="70" height="70">
  <img src="assets/jellyfin.png" alt="Jellyfin" width="70" height="70" >
  <img src="assets/qbittorrent.png" alt="qBittorrent" width="70" height="70">
  <img src="assets/sonarr.png" alt="Sonarr" width="70" height="70">
  <img src="assets/radarr-light.png" alt="Radarr" width="70" height="70">
  <img src="assets/prowlarr.png" alt="Prowlarr" width="70" height="70">
  <img src="assets/bazarr.png" alt="Bazarr" width="70" height="70">
  <img src="assets/komga.png" alt="Komga" width="70" height="70">
  <img src="assets/kavita.png" alt="Kavita" width="70" height="70">
  <img src="assets/gitea.png" alt="Gitea" width="70" height="70">
  <img src="assets/mariadb.png" alt="MariaDB" width="70" height="70">
  <img src="assets/tachidesk.png" alt="TachiDesk" width="70" height="70">
  <img src="assets/trash-guides.png" alt="Trash-Guides" width="70" height="70">
</p>

## Prerequisites

- **Operating System**: Ubuntu/Debian Linux
- **Git**: Required to clone the repository. Install Git with:

  ```bash
  sudo apt install git
  ```

## Quick Setup

To quickly set up the script, use the following commands:

1. **Clone the repository**:

   ```bash
   git clone https://github.com/HASANALI117/home-server.git
   ```

2. **Navigate to the `scripts` directory**:

   ```bash
   cd home-server/scripts
   ```

3. **Make the script executable and run it**:

   ```bash
   chmod +x udms.sh
   ./udms.sh
   ```

Follow the prompts to provide configuration details. Examples of the prompts are:

1. **Enter Time Zone (TZ):**

   ```plaintext
   Enter TZ: Europe/London
   ```

   This prompt asks for your server's time zone. You should enter the appropriate time zone for your location. For a list of time zones, refer to the [Wikipedia Time Zone List](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

2. **Enter Server IP (SERVER_IP):**

   ```plaintext
   Enter SERVER_IP: 192.168.1.100
   ```

   This prompt asks for the IP address of your server. Enter the local IP address where you want to access your services.

3. **Enter Plex Claim (PLEX_CLAIM):**

   ```plaintext
   Enter PLEX_CLAIM: YOUR_PLEX_CLAIM_TOKEN
   ```

   This prompt asks for a Plex claim token. If you’re using Plex, you’ll need to enter your Plex claim token to connect your server to your Plex account. You can keep it empty initially, and add the Plex claim token to the `plex_claim` file in the `SECRETS` directory when you have it. If you don't know what your Plex claim is, you can find it at [Plex Claim](https://plex.tv/claim).

These prompts will help configure essential aspects of your home server setup. Make sure to provide accurate details to ensure that the script configures your environment correctly.

## What the Script Does

The `udms.sh` script performs the following tasks:

1. **Installs Docker and Docker Compose**: Ensures Docker and Docker Compose are installed on your system.

2. **Verifies Installation**: Checks that Docker and Docker Compose are installed correctly.

3. **Sets Up Directories**: Creates the following directories:

   - **`APPDATA`**: Stores application-specific data for Docker services.
   - **`COMPOSE`**: Contains Docker Compose files for different services.
   - **`LOGS`**: Holds log files for Docker services.
   - **`SCRIPTS`**: Stores additional scripts related to Docker and server management.
   - **`SECRETS`**: Keeps sensitive data like Plex claim tokens and other secrets.
   - **`SHARED`**: Directory for shared resources between containers.

4. **Configures Permissions**: Sets appropriate permissions for directories and files to ensure secure access.

5. **Downloads Docker Compose Files**: Retrieves Docker Compose files for various services from remote sources.

6. **Starts Docker Containers**: Launches Docker containers based on the provided configuration.

7. **Service Configuration**: Applies specific configurations to services like qbittorrent and homepage.

8. **Adds Docker Aliases**: Adds useful Docker and bash aliases to your bash configuration for easier management of Docker services and other tasks. For a full list of aliases and usage examples, refer to the [Bash Aliases & Shortcuts](./BASH-ALIASES.md) section.

## Services Managed by the Script

The script sets up Docker Compose files for the following services:

- **`socket-proxy`**: A reverse proxy for managing access to multiple services running on the server. [Documentation](https://github.com/Tecnativa/docker-socket-proxy?tab=readme-ov-file#supported-api-versions)

- **`portainer`**: A lightweight management UI that allows you to easily manage Docker environments. [Documentation](https://docs.portainer.io/)

- **`dozzle`**: A real-time log viewer for Docker containers, providing a web interface to view logs. [Documentation](https://dozzle.dev/guide/getting-started)

- **`homepage`**: A customizable homepage service that provides quick access to various other services. [Documentation](https://gethomepage.dev/latest/installation/docker/)

- **`plex`**: A media server that organizes and streams your personal media collection. [Documentation](https://docs.linuxserver.io/images/docker-plex/)

- **`jellyfin`**: An open-source media server software for managing and streaming your media library. [Documentation](https://docs.linuxserver.io/images/docker-jellyfin/)

- **`qbittorrent`**: A popular torrent client with a built-in web interface for managing torrents. [Documentation](https://docs.linuxserver.io/images/docker-qbittorrent/)

- **`sonarr`**: A TV series manager that automatically downloads and organizes TV shows. [Documentation](https://docs.linuxserver.io/images/docker-sonarr/)

- **`radarr`**: A movie collection manager that automates the process of downloading and organizing movies. [Documentation](https://docs.linuxserver.io/images/docker-radarr/)

- **`prowlarr`**: A Usenet and torrent indexer that integrates with various other services for managing downloads. [Documentation](https://docs.linuxserver.io/images/docker-prowlarr/)

- **`bazarr`**: A companion application to Sonarr and Radarr, providing subtitle management for your media library. [Documentation](https://docs.linuxserver.io/images/docker-bazarr/)

- **`docker-gc`**: A garbage collection tool that automatically cleans up unused Docker containers and images to free up disk space. [Documentation](https://github.com/clockworksoul/docker-gc-cron)

## Adding More Services

There are 75+ apps in the `compose/` directory. For more information on these apps, refer to the [README in the compose directory](./compose/README.md). The script is a work in progress for adding all of them, for now to add more services, follow these steps:

1. **Add Service Configuration**: Copy the desired service's Docker Compose YAML file from the [`compose/`](./compose/) directory.
2. **Update [`master-compose.yml`](./master-compose.yml)**: Add the path to the copied service YAML file in the [`master-compose.yml`](./master-compose.yml) file under the appropriate section.

Example of adding a new service in [`master-compose.yml`](./master-compose.yml):

```yml
include:
  ########################### SERVICES
  # PREFIX udms = Ultimate Docker Media Server
  # HOSTNAME=udms - defined in .env
  # CORE
  - compose/socket-proxy.yml
  - compose/portainer.yml
  - compose/dozzle.yml
  - compose/homepage.yml
  # MEDIA
  - compose/plex.yml
  - compose/jellyfin.yml
  # DOWNLOADERS
  - compose/qbittorrent.yml
  # PVRS
  - compose/radarr.yml
  - compose/sonarr.yml
  - compose/prowlarr.yml
  # COMPLEMENTARY AP

PS
  - compose/bazarr.yml
  # MAINTENANCE
  - compose/docker-gc.yml
  # Add your new service here
  - compose/new-service.yml
```

## Credits

Special thanks to [@anandslab](https://github.com/anandslab) for his amazing guides and resources. The Docker Compose files were taken from his repository [docker-traefik](https://github.com/anandslab/docker-traefik). For more information, check out his guide on setting up a Docker media server [here](https://www.smarthomebeginner.com/docker-media-server-2024/).
