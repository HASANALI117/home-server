#!/bin/bash

# set -e

# Source functions and configurations
source ./functions.sh

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
    edit_qbittorrent_config
    echo
    edit_homepage_config
    echo
    add_docker_aliases
    echo
    start_containers
    echo

    echo "Setup complete."
}

main
