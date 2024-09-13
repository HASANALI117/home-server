#!/bin/bash

# Source configuration file
source ./config.sh

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
        curl -fsSL https://get.docker.com -o install-docker.sh || error_exit "Failed to download Docker installation script."
        sudo sh install-docker.sh || error_exit "Docker installation failed."
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
        cp "$ENV_EXAMPLE" "$ENV_FILE"
        echo ".env file created at $ENV_FILE"
    else
        echo ".env file already exists at $ENV_FILE"
    fi

    PUID=$(id -u)
    PGID=$(id -g)
    
    read -p "Enter TZ [America/New_York]: " TZ
    read -p "Enter SERVER_IP: " SERVER_IP
    read -p "Enter PLEX_CLAIM (leave empty if not available): " PLEX_CLAIM

    [ -n "$PLEX_CLAIM" ] && echo "$PLEX_CLAIM" > "$SECRETS/plex_claim"

    declare -A env_vars=(
        ["HOSTNAME"]="$USER"
        ["USERDIR"]="$USERDIR"
        ["DOCKERDIR"]="$DOCKER_ROOT"
        ["SECRETSDIR"]="$SECRETS"
        ["SERVER_IP"]="$SERVER_IP"
        ["DATADIR"]="$DATADIR"
        ["TZ"]="$TZ"
        ["PUID"]="$PUID"
        ["PGID"]="$PGID"
        ["HOMEPAGE_VAR_PLEX_URL"]="http://$SERVER_IP:32400/web"
        ["HOMEPAGE_VAR_PORTAINER_URL"]="http://$SERVER_IP:9000"
        ["HOMEPAGE_VAR_DOZZLE_URL"]="http://$SERVER_IP:8082"
        ["HOMEPAGE_VAR_JELLYFIN_URL"]="http://$SERVER_IP:8096"
        ["HOMEPAGE_VAR_QBITTORRENT_URL"]="http://$SERVER_IP:8081"
        ["HOMEPAGE_VAR_SONARR_URL"]="http://$SERVER_IP:8989"
        ["HOMEPAGE_VAR_RADARR_URL"]="http://$SERVER_IP:7878"
        ["HOMEPAGE_VAR_PROWLARR_URL"]="http://$SERVER_IP:9696"
        ["HOMEPAGE_VAR_BAZARR_URL"]="http://$SERVER_IP:6767"
    )

    for key in "${!env_vars[@]}"; do
        update_env_var "$key" "${env_vars[$key]}"
    done
}

# Function to update or add environment variables in the .env file
update_env_var() {
    local key=$1
    local value=$2
    if grep -q "^$key=" "$ENV_FILE"; then
        sed -i "s|^$key=.*|$key=$value|" "$ENV_FILE"
    else
        echo "$key=$value" >> "$ENV_FILE"
    fi
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
    cp "$DOCKER_COMPOSE" "$MASTER_COMPOSE"
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
        cp "$COMPOSE_FILES/$service.yml" "$COMPOSE/$service.yml"
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
    echo "Replacing homepage configuration files..."
    
    local files=("bookmarks.yaml" "services.yaml" "settings.yaml" "widgets.yaml")

    for file in "${files[@]}"; do
        cp "$HOMEPAGE_CONFIG/$file" "$HOMEPAGE_DIR/$file"
        echo "Replaced $file"
    done
    
    echo "Homepage configuration files replaced."
}

# Replace qBittorrent configuration file
edit_qbittorrent_config() {
    echo "Replacing qBittorrent configuration file..."
    
    # Ensure the destination directory exists
    mkdir -p "$(dirname "$QBITTORRENT_CONF")"
    
    # Copy the configuration file
    if cp "$QBITTORRENT_CONFIG" "$QBITTORRENT_CONF"; then
        echo "Copied qbittorrent.conf from $QBITTORRENT_CONFIG to $QBITTORRENT_CONF."
    else
        echo "Failed to copy qbittorrent.conf from $QBITTORRENT_CONFIG."
    fi
}

# Add Docker aliases to bash configuration
add_docker_aliases() {
    echo "Adding Docker aliases to $BASH_CONFIG..."
    
    cat <<EOF >> "$BASH_CONFIG"

# Docker Aliases
alias dcup='sudo docker compose -f $MASTER_COMPOSE up -d --build --remove-orphans'
alias dcdown='sudo docker compose -f $MASTER_COMPOSE down --remove-orphans'
alias dcrec='sudo docker compose -f $MASTER_COMPOSE up -d --force-recreate --remove-orphans'
alias dcstop='sudo docker compose -f $MASTER_COMPOSE stop'
alias dcrestart='sudo docker compose -f $MASTER_COMPOSE restart'
alias dcstart='sudo docker compose -f $MASTER_COMPOSE start'
alias dcpull='sudo docker compose -f $MASTER_COMPOSE pull'
alias dclogs='sudo docker compose -f $MASTER_COMPOSE logs -tf --tail="50"'
EOF
    echo "Docker aliases added. Please run 'source $BASH_CONFIG' to apply the changes."
}
