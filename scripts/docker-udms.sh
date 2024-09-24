#!/bin/bash

# set -e

# Source functions and configurations
source ./functions.sh

# Main function
main() {
    print_intro
    echo
    create_directories
    echo
    install_docker
    echo
    verify_docker
    echo
    set_permissions
    echo
    create_compose_files
    echo
    edit_qbittorrent_config
    echo
    edit_homepage_config
    echo
    download_docker_gc_exclude
    echo
    add_docker_aliases
    echo
    start_containers
    echo

    echo "Setup complete."
}

main
