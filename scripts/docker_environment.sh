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
    create_env_file
    set_permissions
    create_compose_files
    done_msg "Docker environment setup complete."
}

# Create necessary directories
create_directories() {
    info_msg "Creating necessary directories..."
    mkdir -p "$APPDATA" "$COMPOSE" "$LOGS" "$SCRIPTS" "$SECRETS" "$SHARED"
    done_msg "Directories created:"
    typing_print "  - $APPDATA"
    typing_print "  - $COMPOSE"
    typing_print "  - $LOGS"
    typing_print "  - $SCRIPTS"
    typing_print "  - $SECRETS"
    typing_print "  - $SHARED"
}

# Create .env file
create_env_file() {
    info_msg "Creating .env file..."

    touch "$ENV_FILE"

    PUID=$(id -u)
    PGID=$(id -g)

    read -p "Enter TZ [America/New_York]: " TZ
    read -p "Enter SERVER_IP: " SERVER_IP
    read -p "Enter PLEX_CLAIM (leave empty if not available): " PLEX_CLAIM

    [ -n "$PLEX_CLAIM" ] && printf "%s" "$PLEX_CLAIM" >"$SECRETS/plex_claim"

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
        echo "$key=${env_vars[$key]}" >>"$ENV_FILE"
    done

    echo
    done_msg ".env file created and has been populated with the necessary environment variables."
}

# Set permissions
set_permissions() {
    info_msg "Setting permissions for secrets folder and .env file..."
    sudo chown root:root "$SECRETS" "$ENV_FILE"
    sudo chmod 600 "$SECRETS" "$ENV_FILE"
    done_msg "Permissions set for secrets folder, .env file and config file."

    info_msg "Setting permissions for Docker root folder..."
    sudo apt install -y acl || error_exit "Failed to install ACL."
    sudo chmod 775 "$DOCKER_ROOT"
    sudo setfacl -Rdm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rdm g:docker:rwx "$DOCKER_ROOT"
    sudo setfacl -Rm g:docker:rwx "$DOCKER_ROOT"
    done_msg "Permissions set for Docker root folder: $DOCKER_ROOT"

    info_msg "Setting permissions for Jellyfin directory..."
    if [ ! -d "$DOCKER_ROOT/appdata/jellyfin" ]; then
        info_msg "Jellyfin directory does not exist. Creating directory..."
        sudo mkdir -p "$DOCKER_ROOT/appdata/jellyfin"
        done_msg "Jellyfin directory created: $DOCKER_ROOT/appdata/jellyfin"
    fi
    sudo chown -R "$USER":"$USER" "$DOCKER_ROOT/appdata/jellyfin"
    done_msg "Permissions set for Jellyfin directory: $DOCKER_ROOT/appdata/jellyfin"
}

# Create Docker Compose files
create_compose_files() {
    info_msg "Creating master docker-compose file..."
    cp "$DOCKER_COMPOSE" "$MASTER_COMPOSE"
    done_msg "Master docker-compose file created: $MASTER_COMPOSE"

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
        "kavita"
        "bazarr"
        "docker-gc"
        "vscode"
    )

    info_msg "Creating compose files..."
    for service in "${services[@]}"; do
        cp "$COMPOSE_FILES/$service.yml" "$COMPOSE/$service.yml"
        typing_print "Created: $COMPOSE/$service.yml"
    done
    done_msg "Compose files created."
}

# Start Docker containers
start_containers() {
    echo -e "\e[36m"
    typing_print "================================================"
    typing_print "  Step 5: Starting Docker containers...         "
    typing_print "================================================"
    echo -e "\e[0m"
    sudo docker compose -f "$MASTER_COMPOSE" up -d || error_exit "Failed to start containers."
}
