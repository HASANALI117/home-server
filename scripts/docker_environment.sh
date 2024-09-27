#!/bin/bash

# Source configuration file
source ../configs/config.env
source ./utilities.sh

# Function to set up the Docker environment
setup_docker_environment() {
    echo -e "\e[36m"
    typing_print "================================================"
    typing_print "  Step 2: Setting up Docker environment...      "
    typing_print "================================================"
    echo -e "\e[0m"
    create_directories
    create_env
    set_permissions
    create_compose_files
    echo -e "\e[32m"
    typing_print "Docker environment setup complete."
    echo -e "\e[0m"
    start_containers
}

# Create necessary directories
create_directories() {
    typing_print "Creating necessary directories..."
    mkdir -p "$APPDATA" "$COMPOSE" "$LOGS" "$SCRIPTS" "$SECRETS" "$SHARED"
    typing_print "Directories created:"
    typing_print "  - $APPDATA"
    typing_print "  - $COMPOSE"
    typing_print "  - $LOGS"
    typing_print "  - $SCRIPTS"
    typing_print "  - $SECRETS"
    typing_print "  - $SHARED"
}

# Create .env file
create_env_file() {
    typing_print "Creating .env file..."

    touch "$ENV_FILE"

    PUID=$(id -u)
    PGID=$(id -g)
    
    read -p "Enter TZ [America/New_York]: " TZ
    read -p "Enter SERVER_IP: " SERVER_IP
    read -p "Enter PLEX_CLAIM (leave empty if not available): " PLEX_CLAIM

    [ -n "$PLEX_CLAIM" ] && echo "$PLEX_CLAIM" | sudo tee "$SECRETS/plex_claim" > /dev/null

    declare -A env_vars=(
        ["HOSTNAME"]="$HOSTNAME"
        ["USERDIR"]="$HOME"
        ["DOCKERDIR"]="$DOCKER_ROOT"
        ["SECRETSDIR"]="$SECRETS"
        ["SERVER_IP"]="$SERVER_IP"
        ["DATADIR"]="$DATADIR"
        ["TZ"]="$TZ"
        ["PUID"]="$PUID"
        ["PGID"]="$PGID"
        ["PLEX_CLAIM"]="$PLEX_CLAIM"
        ["LOCAL_IPS"]=127.0.0.1/32,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12
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
        echo "$key=${env_vars[$key]}" >> "$ENV_FILE"
    done

    echo
    typing_print ".env file created and has been populated with the necessary environment variables."
}

# Set permissions
set_permissions() {
    typing_print "Setting permissions for secrets folder and .env file..."
    sudo chown root:root "$SECRETS" "$ENV_FILE"
    sudo chmod 600 "$SECRETS" "$ENV_FILE"
    typing_print "Permissions set for secrets folder, .env file and config file."

    typing_print "Setting permissions for Docker root folder..."
    sudo apt install -y acl || error_exit "Failed to install ACL."
    sudo chmod 775 "$DOCKER_ROOT"
    sudo setfacl -Rdm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rdm g:docker:rwx "$DOCKER_ROOT"
    sudo setfacl -Rm g:docker:rwx "$DOCKER_ROOT"
    typing_print "Permissions set for Docker root folder: $DOCKER_ROOT"

    typing_print "Setting permissions for Jellyfin directory..."
    sudo chown -R "$USER":"$USER" "$DOCKER_ROOT/appdata/jellyfin"
    typing_print "Permissions set for Jellyfin directory: $DOCKER_ROOT/appdata/jellyfin"
}

# Create Docker Compose files
create_compose_files() {
    typing_print "Creating master docker-compose file..."
    cp "$DOCKER_COMPOSE" "$MASTER_COMPOSE"
    typing_print "Master docker-compose file created: $MASTER_COMPOSE"

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

    typing_print "Creating compose files..."
    for service in "${services[@]}"; do
        cp "$COMPOSE_FILES/$service.yml" "$COMPOSE/$service.yml"
        typing_print "Created: $COMPOSE/$service.yml"
    done
    typing_print "Compose files created."
}

# Start Docker containers
start_containers() {
    typing_print "Starting the containers..."
    sudo docker compose -f "$MASTER_COMPOSE" up -d || error_exit "Failed to start containers."
}