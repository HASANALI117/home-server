#!/bin/bash

# Source configuration file
source ../configs/config.env
source ./utilities.sh

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
        verify_docker
    fi
}

# Verify Docker installation
verify_docker() {
    typing_print "Verifying Docker installation..."
    sudo docker --version || error_exit "Docker is not installed correctly."
    sudo docker compose version || error_exit "Docker Compose is not installed correctly."
    typing_print "Docker installation verified."
}