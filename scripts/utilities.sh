#!/bin/bash

# Source configuration file
source ../configs/config.env

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

# Enhanced print functions with gum fallback
typing_print() {
    if command -v gum &>/dev/null; then
        gum style --margin "1 2" "$1"
    else
        local text="$1"
        for ((i = 0; i < ${#text}; i++)); do
            echo -n "${text:$i:1}"
            sleep 0.03
        done
        echo
    fi
}

# Error handling
error_exit() {
    local message="$1"
    echo -e "$(printf "\e[31m[ERROR] $message\e[0m")" | tee -a "$LOGS/error.log" 1>&2
    exit 255
}

# Info printing
info_msg() {
    local message="$1"
    typing_print "$(echo -e "\e[34m[INFO]\e[0m $message")"
}

# Done printing
done_msg() {
    local message="$1"
    typing_print "$(echo -e "\e[32m[DONE]\e[0m $message")"
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
    typing_print "Initializing UDMS setup..."
}

print_setup_complete() {
    echo -e "\e[32m"
    typing_print "================================================"
    typing_print "                                                "
    typing_print "      ██████╗  ██████╗ ███╗   ██╗███████╗       "
    typing_print "      ██╔══██╗██╔═══██╗████╗  ██║██╔════╝       "
    typing_print "      ██║  ██║██║   ██║██╔██╗ ██║█████╗         "
    typing_print "      ██║  ██║██║   ██║██║╚██╗██║██╔══╝         "
    typing_print "      ██████╔╝╚██████╔╝██║ ╚████║███████╗       "
    typing_print "      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝       "
    typing_print "                                                "
    typing_print "================================================"
    typing_print "                                                "
    typing_print "                Setup complete.                 "
    typing_print "                                                "
    typing_print "================================================"
    echo -e "\e[0m"
}
