#!/bin/bash

set -e

install_docker() {
    echo "Installing Docker and Docker Compose..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    echo "Docker and Docker Compose installed."
}

verify_docker() {
    echo "Verifying Docker installation..."
    docker --version
    docker-compose --version
    echo "Docker installation verified."
}

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
}

set_permissions() {
    echo "Setting permissions for secrets folder and .env file..."
    sudo chown root:root "$SECRETS" "$ENV_FILE"
    sudo chmod 600 "$SECRETS" "$ENV_FILE"
    echo "Permissions set for secrets folder and .env file."

    echo "Setting permissions for Docker root folder..."
    sudo apt install -y acl
    sudo chmod 775 "$DOCKER_ROOT"
    sudo setfacl -Rdm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rm u:"$USER":rwx "$DOCKER_ROOT"
    sudo setfacl -Rdm g:docker:rwx "$DOCKER_ROOT"
    sudo setfacl -Rm g:docker:rwx "$DOCKER_ROOT"
    echo "Permissions set for Docker root folder: $DOCKER_ROOT"
}

copy_compose_files() {
    echo "Creating master docker-compose file..."
    cp "$DOCKER_ROOT/docker-compose-udms.yml" "$MASTER_COMPOSE"
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

    echo "Copying compose files..."
    for service in "${services[@]}"; do
        cp "$DOCKER_ROOT/compose/$service.yml" "$COMPOSE/$service.yml"
    done
    echo "Compose files copied."
}

add_additional_containers() {
    while true; do
        read -r -p "Do you want to add more containers? (yes/no) " yn
        case $yn in
            [Yy]* ) 
                read -r -p "Enter the name of the container: " container
                cp "$DOCKER_ROOT/compose/$container.yml" "$COMPOSE/$container.yml"
                ;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

start_containers() {
    echo "Starting the containers..."
    docker-compose -f "$MASTER_COMPOSE" up -d
}

edit_homepage_config() {
    local CONFIG_DIR="configs/homepage/docker-configs"
    local HOMEPAGE_DIR="$APPDATA/homepage"
    
    echo "Replacing homepage configuration files..."
    
    local files=("bookmarks.yaml" "services.yaml" "settings.yaml" "widgets.yaml")
    
    for file in "${files[@]}"; do
        if [ -f "$CONFIG_DIR/$file" ]; then
            cp "$CONFIG_DIR/$file" "$HOMEPAGE_DIR/$file"
            echo "Replaced $file"
        else
            echo "$file not found in $CONFIG_DIR"
        fi
    done
    
    echo "Homepage configuration files replaced."
}

stop_qbittorrent() {
    echo "Stopping qbittorrent container..."
    docker stop qbittorrent
    echo "qbittorrent container stopped."
}

edit_qbittorrent_config() {
    QBITTORRENT_CONF="$APPDATA/qbittorrent/qbittorrent.conf"
    if [ -f "$QBITTORRENT_CONF" ]; then
        echo "Editing qbittorrent.conf..."
        echo "WebUI\Username=admin" >> "$QBITTORRENT_CONF"
        echo "WebUI\Password_PBKDF2=@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)" >> "$QBITTORRENT_CONF"
        echo "qbittorrent.conf edited."
    else
        echo "qbittorrent.conf not found."
    fi
}

start_qbittorrent() {
    echo "Starting qbittorrent container..."
    docker start qbittorrent
    echo "qbittorrent container started."
}

main() {
    read -r -p "Enter your username: " USER
    DOCKER_ROOT="/home/$USER/docker"
    APPDATA="$DOCKER_ROOT/appdata"
    COMPOSE="$DOCKER_ROOT/compose"
    LOGS="$DOCKER_ROOT/logs"
    SCRIPTS="$DOCKER_ROOT/scripts"
    SECRETS="$DOCKER_ROOT/secrets"
    SHARED="$DOCKER_ROOT/shared"
    ENV_FILE="$DOCKER_ROOT/.env"
    MASTER_COMPOSE="$DOCKER_ROOT/docker-compose-udms.yml"

    install_docker
    verify_docker
    create_directories
    set_permissions
    copy_compose_files
    add_additional_containers
    start_containers
    edit_homepage_config
    stop_qbittorrent
    edit_qbittorrent_config
    start_qbittorrent

    echo "Setup complete."
}

main