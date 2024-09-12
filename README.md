# Home Server Automation

This repository automates the setup and management of my home server using Docker and Docker Compose.

<p align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/e/ea/Docker_%28container_engine%29_logo_%28cropped%29.png" alt="Portainer" width="120" height="80">
  <img src="https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_200,h_200/https://api.charmhub.io/api/v1/media/download/charm_Owpj9CsDEMZwVtup3ZTxxs0FtyvDqb2o_icon_5cef79c2d18f67464f39c8f2cf2d7ebb815b0071f04d3ffbb94f49fddd3ab666.png" alt="Portainer" width="80" height="80">
  <img src="https://avatars.githubusercontent.com/u/122929872?v=4" alt="Homepage" width="80" height="80">
  <img src="https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/plex-logo.png" alt="Plex" width="80" height="80">
  <img src="https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/jellyfin-logo.png" alt="Jellyfin" width="80" height="80">
  <img src="https://github.com/linuxserver/docker-templates/raw/master/linuxserver.io/img/qbittorrent-icon.png" alt="qBittorrent" width="80" height="80">
  <img src="https://github.com/Sonarr/Sonarr/raw/develop/Logo/256.png" alt="Sonarr" width="80" height="80">
  <img src="https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/radarr.png" alt="Radarr" width="80" height="80">
  <img src="https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/prowlarr-banner.png" alt="Prowlarr" width="80" height="80">
  <img src="https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/bazarr.png" alt="Bazarr" width="80" height="80">
</p>

## Quick Setup

To quickly set up the script, use the following command:

```bash
curl -O "https://raw.githubusercontent.com/HASANALI117/home-server/main/docker-udms.sh"
```

After downloading, make the script executable and run it:

```bash
chmod +x docker-udms.sh
./docker-udms.sh
```

Follow the prompts to provide configuration details. Examples of the prompts are:

1. **Enter Time Zone (TZ):**

   ```
   Enter TZ: Europe/London
   ```

   This prompt asks for your server's time zone. You should enter the appropriate time zone for your location. For a list of time zones, refer to the [Wikipedia Time Zone List](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

2. **Enter Server IP (SERVER_IP):**

   ```
   Enter SERVER_IP: 192.168.1.100
   ```

   This prompt asks for the IP address of your server. Enter the local IP address where you want to access your services.

3. **Enter Plex Claim (PLEX_CLAIM):**
   ```
   Enter PLEX_CLAIM: YOUR_PLEX_CLAIM_TOKEN
   ```
   This prompt asks for a Plex claim token. If you’re using Plex, you’ll need to enter your Plex claim token to connect your server to your Plex account. You can keep it empty initially, and add the Plex claim token to the `plex_claim` file in the `SECRETS` directory when you have it. If you don't know what your Plex claim is, you can find it at [Plex Claim](https://plex.tv/claim).

These prompts will help configure essential aspects of your home server setup. Make sure to provide accurate details to ensure that the script configures your environment correctly.

## What the Script Does

The `docker-udms.sh` script performs the following tasks:

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

To add more services, follow these steps:

1. **Add Service Configuration**: Copy the desired service's Docker Compose YAML file from the [`compose/`]() directory.
2. **Update [`docker-compose-udms.yml`]()**: Add the path to the copied service YAML file in the [`docker-compose-udms.yml`]() file under the appropriate section.

Example of adding a new service in [`docker-compose-udms.yml`]():

```yml
include:
  ########################### SERVICES
  # PREFIX udms = Ultimate Docker Media Server
  # HOSTNAME=udms - defined in .env
  # CORE
  - compose/$HOSTNAME/socket-proxy.yml
  - compose/$HOSTNAME/portainer.yml
  - compose/$HOSTNAME/dozzle.yml
  - compose/$HOSTNAME/homepage.yml
  # MEDIA
  - compose/$HOSTNAME/plex.yml
  - compose/$HOSTNAME/jellyfin.yml
  # DOWNLOADERS
  - compose/$HOSTNAME/qbittorrent.yml
  # PVRS
  - compose/$HOSTNAME/radarr.yml
  - compose/$HOSTNAME/sonarr.yml
  - compose/$HOSTNAME/prowlarr.yml
  # COMPLEMENTARY APPS
  - compose/$HOSTNAME/bazarr.yml
  # MAINTENANCE
  - compose/$HOSTNAME/docker-gc.yml
  # Add your new service here
  - compose/$HOSTNAME/new-service.yml
```
