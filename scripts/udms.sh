#!/bin/bash

# Source functions
source ./utilities.sh
source ./install_docker.sh
source ./docker_environment.sh
source ./config_creation.sh
source ./add_docker_aliases.sh
source ./service-manager.sh

# Main function
main() {
    print_intro
    check_dependencies # New dependency check
    install_docker
    setup_docker_environment
    create_configs
    add_docker_aliases

    if [ "$1" = "--tui" ]; then
        manage_services
    else
        start_containers
    fi

    print_setup_complete
}

# Start
main "$@"
