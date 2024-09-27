#!/bin/bash

# Source configuration file
source ./config.sh

# Function to create typing effect
typing_print() {
    local text="$1"
    local delay=0.0001
    
    # Print each character with delay
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Intro message with logo
print_intro() {
    clear
    echo -e "\e[36m"
    typing_print "=============================================="
    typing_print "                                              "
    typing_print "      ██╗   ██╗██████╗ ███╗   ███╗███████╗    "
    typing_print "      ██║   ██║██╔══██╗████╗ ████║██╔════╝    "
    typing_print "      ██║   ██║██║  ██║██╔████╔██║███████╗    "
    typing_print "      ██║   ██║██║  ██║██║╚██╔╝██║╚════██║    "
    typing_print "      ╚██████╔╝██████╔╝██║ ╚═╝ ██║███████║    "
    typing_print "      ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝     "
    typing_print "                                              "
    typing_print "=============================================="
    typing_print "                                              "
    typing_print "Welcome to UDMS (Ultimate Docker Media Server)"
    typing_print "                                              "
    typing_print "=============================================="
    echo -e "\e[0m"
}

# Error handling
error_exit() {
    message="$1"
    echo -e "$(printf "\e[31m$message\e[0m")" | tee -a "$LOGS/error.log" 1>&2
    exit 255
}

# Install Docker and Docker Compose
install_docker() {
    echo -e "\e[36m"
    typing_print "================================================"
    typing_print "  Step 1: Installing Docker and Docker Compose  "
    typing_print "================================================"
    typing_print "                      ##        .               "
    typing_print "                ## ## ##       ==               "
    typing_print "             ## ## ## ##      ===               "
    typing_print "         /""""""""""""""""\___/ ===             "
    typing_print "    ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~      "
    typing_print "         \______ o          __/                 "
    typing_print "           \    \        __/                    "
    typing_print "            \____\______/                       "
    typing_print "================================================"
    echo -e "\e[0m"

    # Check if curl is installed, if not, install it
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Installing curl..."
        sudo apt-get update || error_exit "Failed to update package list."
        sudo apt-get install -y curl || error_exit "Failed to install curl."
        echo "curl installed successfully."
    fi

    # Check if docker is installed, if not, install it
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o install-docker.sh || error_exit "Failed to download Docker installation script."
        sudo sh install-docker.sh || error_exit "Docker installation failed."
        typing_print "Docker and Docker Compose installed."
    else
        typing_print "Docker is already installed."
    fi
}

# Verify Docker installation
verify_docker() {
    typing_print "Verifying Docker installation..."
    sudo docker --version || error_exit "Docker is not installed correctly."
    sudo docker compose version || error_exit "Docker Compose is not installed correctly."
    typing_print "Docker installation verified."
}

# Create .env file
create_env_file() {
    typing_print "Creating .env file..."

    touch "$ENV_FILE"
    typing_print ".env file created at $ENV_FILE"

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
    typing_print ".env file has been populated with the necessary environment variables."
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

    # Create .env file
    create_env_file
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

# Replace homepage configuration files
create_homepage_config() {
    typing_print "Creating homepage configuration files..."

    # Ensure the destination directory exists
    mkdir -p "$APPDATA/homepage"
        
    local files=("bookmarks.yaml" "services.yaml" "settings.yaml" "widgets.yaml")

    # Copy the configuration files
    for file in bookmarks.yaml services.yaml settings.yaml widgets.yaml; do
        if cp "$HOMEPAGE_CONFIG/$file" "$APPDATA/homepage/$file"; then
            typing_print "Created $file"
        else
            echo "Failed to create $file"
        fi
    done
    
    typing_print "Homepage configuration files created."
}

# Replace qBittorrent configuration file
create_qbittorrent_config() {
    typing_print "Creating qBittorrent configuration file..."
    
    # Ensure the destination directory exists
    mkdir -p "$(dirname "$QBITTORRENT_CONF")"
    
    # Copy the configuration file
    if cp "$QBITTORRENT_CONFIG" "$QBITTORRENT_CONF"; then
        typing_print "Created $QBITTORRENT_CONF."
    else
        echo "Failed to create qbittorrent.conf."
    fi
}

# Add Docker aliases to bash configuration
add_docker_aliases() { 
    typing_print "Adding Docker aliases..."

    # Copy bash_aliases.env.example to $BASH_ENV
    if [[ -f "./bash_aliases.env.example" ]]; then
        mkdir -p "$SHARED/config"
        cp "./bash_aliases.env.example" "$BASH_ENV"
        typing_print "Created $BASH_ENV."
    else
        error_exit "bash_aliases.env.example file not found in the current directory."
    fi

    # Add variables to bash_aliases.env file
    cat "./config.sh" >> "$BASH_ENV"

    # Check if bash_aliases file exists in the same directory as the script
    if [[ -f "./bash_aliases" ]]; then
        # Append the contents of bash_aliases to the bash configuration
        cat "./bash_aliases" >> "$BASH_CONFIG"
        typing_print "Docker aliases added to $BASH_CONFIG."
    else
        error_exit "bash_aliases file not found in the current directory."
    fi

    # Ensure .bashrc sources .bash_aliases
    if ! grep -q "source $BASH_CONFIG" "$BASHRC"; then
        echo "source $BASH_CONFIG" >> "$BASHRC"
        typing_print "Added 'source $BASH_CONFIG' to $BASHRC to load .bash_aliases."
    else
        typing_print "$BASHRC already sources $BASH_CONFIG."
    fi

    # Source the .bashrc to apply changes immediately
    source "$BASHRC"
}

# Function to create docker-gc-exclude file
create_docker_gc_exclude() {
    typing_print "Creating docker-gc-exclude file..."

    # Ensure the destination directory exists
    mkdir -p "$APPDATA/docker-gc"

    # Copy the docker-gc-exclude file from the local directory
    cp "$DOCKERGC_EXCLUDE" "$APPDATA/docker-gc/docker-gc-exclude"
    if [ $? -eq 0 ]; then
        typing_print "docker-gc-exclude file created successfully."
    else
        error_exit "Failed to create docker-gc-exclude file."
    fi
}

print_setup_complete() {
    echo -e "\e[32m"
    typing_print "██████╗  ██████╗ ███╗   ██╗███████╗"
    typing_print "██╔══██╗██╔═══██╗████╗  ██║██╔════╝"
    typing_print "██║  ██║██║   ██║██╔██╗ ██║█████╗  "
    typing_print "██║  ██║██║   ██║██║╚██╗██║██╔══╝  "
    typing_print "██████╔╝╚██████╔╝██║ ╚████║███████╗"
    typing_print "╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝"
    typing_print "Setup complete."
    echo -e "\e[0m"
}