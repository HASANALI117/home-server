#!/bin/bash

# Source configuration file
source ../configs/config.env
source ./utilities.sh

# Create all configuration files
create_configs() {
    echo -e "\e[36m"
    typing_print "================================================"
    typing_print "  Step 3: Creating configuration files...       "
    typing_print "================================================"
    echo -e "\e[0m"
    create_homepage_config
    create_qbittorrent_config
    create_docker_gc_exclude
}

# Create homepage configuration files
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

# Create qBittorrent configuration file
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


# Create docker-gc-exclude file
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