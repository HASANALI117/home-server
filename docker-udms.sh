#!/bin/bash

set -e

# Configuration variables
USER=$(whoami)
USERDIR="/home/$USER"
DOCKER_ROOT="$USERDIR/docker"
APPDATA="$DOCKER_ROOT/appdata"
COMPOSE="$DOCKER_ROOT/compose"
LOGS="$DOCKER_ROOT/logs"
SCRIPTS="$DOCKER_ROOT/scripts"
SECRETS="$DOCKER_ROOT/secrets"
SHARED="$DOCKER_ROOT/shared"
ENV_FILE="$DOCKER_ROOT/.env"
MASTER_COMPOSE="$DOCKER_ROOT/docker-compose-udms.yml"
ENV_EXAMPLE_URL="https://raw.githubusercontent.com/HASANALI117/home-server/main/.env.example"
DOCKER_COMPOSE_URL="https://raw.githubusercontent.com/HASANALI117/home-server/main/docker-compose-udms.yml"
HOMEPAGE_CONFIG_URL="https://raw.githubusercontent.com/HASANALI117/home-server/main/configs/homepage/docker-configs"

# Helper function to print error messages
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# Function to install Docker and Docker Compose
install_docker() {
    echo "Installing Docker and Docker Compose..."
    curl -fsSL https://get.docker.com -o get-docker.sh || error_exit "Failed to download Docker installation script."
    sudo sh get-docker.sh || error_exit "Docker installation failed."
    echo "Docker and Docker Compose installed."
}

# Function to verify Docker installation
verify_docker() {
    echo "Verifying Docker installation..."
    sudo docker version || error_exit "Docker is not installed correctly."
    sudo docker compose version || error_exit "Docker Compose is not installed correctly."
    echo "Docker installation verified."
}

# Function to create the .env file
create_env_file() {
    if [ ! -f "$ENV_FILE" ]; then
        curl -o "$ENV_FILE" "$ENV_EXAMPLE_URL" || error_exit "Failed to download .env.example."
        echo ".env file created at $ENV_FILE"
    else
        echo ".env file already exists at $ENV_FILE"
    fi

    PUID=$(id -u)
    echo "PUID=$PUID" >> "$ENV_FILE"
    
    PGID=$(id -g)
    echo "PGID=$PGID" >> "$ENV_FILE"
    
    read -p "Enter TZ: " TZ
    echo "TZ=$TZ" >> "$ENV_FILE"

    read -p "Enter SERVER_IP: " SERVER_IP
    echo "SERVER_IP=$SERVER_IP" >> "$ENV_FILE"

    read -p "Enter PLEX_CLAIM: " PLEX_CLAIM
    echo "PLEX_CLAIM=$PLEX_CLAIM" >> "$ENV_FILE"
    echo "PLEX_CLAIM=\$PLEX_CLAIM" > "$SECRETS/plex_claim"

    echo "USERDIR=$USERDIR" >> "$ENV_FILE"
    echo "DOCKERDIR=$DOCKER_ROOT" >> "$ENV_FILE"
    echo "SECRETSDIR=$SECRETS" >> "$ENV_FILE"
}

# Function to create necessary directories
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

# Function to set permissions
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

# Function to create Docker Compose files
create_compose_files() {
    echo "Creating master docker-compose file..."
    curl -o "$MASTER_COMPOSE" "$DOCKER_COMPOSE_URL" || error_exit "Failed to download master docker-compose file."
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
        curl -o "$COMPOSE/$service.yml" "https://raw.githubusercontent.com/HASANALI117/home-server/main/compose/$service.yml" || error_exit "Failed to download compose file for $service."
        echo "Created: $COMPOSE/$service.yml"
    done
    echo "Compose files created."
}

# Function to start Docker containers
start_containers() {
    echo "Starting the containers..."
    sudo docker compose -f "$MASTER_COMPOSE" up -d || error_exit "Failed to start containers."
}

# Function to replace homepage configuration files
edit_homepage_config() {
    local HOMEPAGE_DIR="$APPDATA/homepage"
    
    echo "Replacing homepage configuration files..."
    
    local files=("bookmarks.yaml" "services.yaml" "settings.yaml" "widgets.yaml")

    for file in "${files[@]}"; do
        curl -o "$HOMEPAGE_DIR/$file" "$HOMEPAGE_CONFIG_URL/$file" || error_exit "Failed to download $file for homepage."
        echo "Replaced $file"
    done
    
    echo "Homepage configuration files replaced."
}

# Function to stop qbittorrent container
stop_qbittorrent() {
    echo "Stopping qbittorrent container..."
    sudo docker compose -f "$COMPOSE/qbittorrent.yml" down || error_exit "Failed to stop qbittorrent container."
    echo "qbittorrent container stopped."
}

# Function to edit qbittorrent configuration
edit_qbittorrent_config() {
    QBITTORRENT_CONF="$APPDATA/qbittorrent/qBittorrent/qBittorrent.conf"
    if [ -f "$QBITTORRENT_CONF" ]; then
        echo "Editing qbittorrent.conf..."
        echo "WebUI\\Username=admin" >> "$QBITTORRENT_CONF"
        echo "WebUI\\Password_PBKDF2=@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)" >> "$QBITTORRENT_CONF"
        echo "qbittorrent.conf edited."
    else
        echo "qbittorrent.conf not found."
    fi
}

# Function to start qbittorrent container
start_qbittorrent() {
    echo "Starting qbittorrent container..."
    sudo docker compose -f "$COMPOSE/qbittorrent.yml" up -d || error_exit "Failed to start qbittorrent container."
    echo "qbittorrent container started."
}

# Main function
main() {
    install_docker
    echo
    verify_docker
    echo
    create_directories
    echo
    set_permissions
    echo
    create_compose_files
    echo
    start_containers
    echo
    edit_homepage_config
    echo
    stop_qbittorrent
    echo
    edit_qbittorrent_config
    echo
    start_qbittorrent
    echo

    echo "Setup complete."
}

main
