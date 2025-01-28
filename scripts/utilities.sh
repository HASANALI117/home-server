#!/bin/bash

# Source configuration file
source ../configs/config.env

# Error handling function
handle_error() {
    gum style --foreground 196 --bold "Error: $1"
    sleep 2
    return 1
}

# Success notification
success_msg() {
    gum style --foreground 46 --bold "$1"
    sleep 1
}

# Dependency checks
check_dependencies() {
    # Check for curl
    if ! command -v curl &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y curl
    fi

    # Install gum if missing
    if ! command -v gum &>/dev/null; then
        info_msg "Installing gum TUI toolkit..."
        if ! curl -fsSL https://raw.githubusercontent.com/charmbracelet/gum/main/install.sh | sudo bash; then
            error_exit "Failed to install gum! Please install manually and retry."
        fi
    fi

    # Verify yq
    if ! command -v yq &>/dev/null; then
        info_msg "Installing yq YAML processor..."
        sudo apt-get install -y yq
    fi
}
