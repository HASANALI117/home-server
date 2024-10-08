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
    create_qbittorrent_config
    echo
    create_homepage_config
    echo
    create_docker_gc_exclude
    echo
    add_docker_aliases
    echo
    start_containers
    echo
    print_setup_complete
}

main
