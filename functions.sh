#!/bin/bash

# Error handling
error_exit() {
    echo "$1" | tee -a "$LOGS/error.log" 1>&2
    exit 1
}

# Download file helper function
download_file() {
    local url="$1"
    local destination="$2"
    curl -o "$destination" "$url" || error_exit "Failed to download $url"
}

# Install Docker and Docker Compose
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker and Docker Compose..."
        curl -fsSL https://get.docker.com -o get-docker.sh || error_exit "Failed to download Docker installation script."
        sudo sh get-docker.sh || error_exit "Docker installation failed."
        echo "Docker and Docker Compose installed."
    else
        echo "Docker is already installed."
    fi
}

# Verify Docker installation
verify_docker() {
    echo "Verifying Docker installation..."
    sudo docker version || error_exit "Docker is not installed correctly."
    sudo docker compose version || error_exit "Docker Compose is not installed correctly."
    echo "Docker installation verified."
}

# Create .env file
create_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        download_file "$ENV_EXAMPLE_URL" "$ENV_FILE"
        echo ".env file created at $ENV_FILE"
    else
        echo ".env file already exists at $ENV_FILE"
    fi

    PUID=$(id -u)
    PGID=$(id -g)
    
    read -p "Enter TZ [America/New_York]: " TZ
    TZ=${TZ:-"America/New_York"}
    read -p "Enter SERVER_IP: " SERVER_IP
    read -p "Enter PLEX_CLAIM (leave empty if not available): " PLEX_CLAIM

    [ -n "$PLEX_CLAIM" ] && echo "$PLEX_CLAIM" > "$SECRETS/plex_claim"

    cat <<EOF >> "$ENV_FILE"
HOSTNAME="$USER"
USERDIR="$USERDIR"
DOCKERDIR="$DOCKER_ROOT"
SECRETSDIR="$SECRETS"
SERVER_IP="$SERVER_IP"
DATADIR="$DATADIR"
TZ="$TZ"
PUID="$PUID"
PGID="$PGID"
EOF
}

# Create necessary directories
create_directories() {
    echo "Creating necessary directories..."
    mkdir -p "$APPDATA" "$COMPOSE" "$LOGS" "$SCRIPTS" "$SECRETS" "$SHARED"
    echo "Directories created:"
    echo "  - $APPDATA"
    echo "  - $COMPOSE"
    echo "  - $LOGS"
    echo "  - $SCRIPTS"
    echo "  - $SECRETS"
    echo "  - $SHARED"

    create_env_file
}

# Set permissions
set_permissions() {
    echo "Setting permissions for secrets folder and .env file..."
    sudo chown root:root "$SECRETS" "$ENV_FILE"
    sudo chmod 600 "$SECRETS" "$ENV_FILE"
    echo "Permissions set for secrets folder and .env file."

    echo "Setting permissions for Docker root folder..."
    sudo apt install -y acl || error_exit "Failed to install ACL."
    sudo chmod 775 "$DOCKER_ROOT"
    sudo setfacl -Rdm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rdm g:docker:rwx "$DOCKER_ROOT"
    sudo setfacl -Rm g:docker:rwx "$DOCKER_ROOT"
    echo "Permissions set for Docker root folder: $DOCKER_ROOT"
}

# Create Docker Compose files
create_compose_files() {
    echo "Creating master docker-compose file..."
    download_file "$DOCKER_COMPOSE_URL" "$MASTER_COMPOSE"
    echo "Master docker-compose file created: $MASTER_COMPOSE"

    local services=(
        "socket-proxy"
        "portainer"
        "dozzle"
        "homepage"
        "plex"
        "jellyfin"
        "qbittorrent"
        "sonarr"
        "radarr"
        "prowlarr"
        "bazarr"
        "docker-gc"
    )

    echo "Creating compose files..."
    for service in "${services[@]}"; do
        download_file "$COMPOSE_FILES_URL/$service.yml" "$COMPOSE/$service.yml"
        echo "Created: $COMPOSE/$service.yml"
    done
    echo "Compose files created."
}

# Start Docker containers
start_containers() {
    echo "Starting the containers..."
    sudo docker compose -f "$MASTER_COMPOSE" up -d || error_exit "Failed to start containers."
}

# Replace homepage configuration files
edit_homepage_config() {
    local HOMEPAGE_DIR="$APPDATA/homepage"
    
    echo "Replacing homepage configuration files..."
    
    local files=("bookmarks.yaml" "services.yaml" "settings.yaml" "widgets.yaml")

    for file in "${files[@]}"; do
        download_file "$HOMEPAGE_CONFIG_URL/$file" "$HOMEPAGE_DIR/$file"
        echo "Replaced $file"
    done
    
    echo "Homepage configuration files replaced."
}

# Edit qbittorrent configuration
edit_qbittorrent_config() {
    sudo docker compose -f "$MASTER_COMPOSE" down

    QBITTORRENT_CONF="$APPDATA/qbittorrent/qBittorrent/qBittorrent.conf"

    echo "Downloading qbittorrent.conf from $QBITTORRENT_CONFIG_URL..."
    if curl -o "$QBITTORRENT_CONF" "$QBITTORRENT_CONFIG_URL"; then
        echo "qbittorrent.conf downloaded and updated."
    else
        echo "Failed to download qbittorrent.conf from $QBITTORRENT_CONFIG_URL." >&2
        exit 1
    fi
}
