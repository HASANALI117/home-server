#!/bin/bash

# set -e

# Source functions and configurations
source ./utilities.sh
source ./install_docker.sh
source ./docker_environment.sh
source ./config_creation.sh
source ./add_docker_aliases.sh

# Main function
main() {
    print_intro
    echo
    install_docker
    echo
    setup_docker_environment
    echo
    create_configs
    echo
    add_docker_aliases
    echo
    start_containers
    echo
    print_setup_complete
}

main
