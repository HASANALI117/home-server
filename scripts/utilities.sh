#!/bin/bash

# Source configuration file
source ../configs/config.env

# Function to create typing effect
typing_print() {
    local text="$1"
    local delay=0.0001
    
    # Print each character with delay
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo ""
}

# Error handling
error_exit() {
    message="$1"
    echo -e "$(printf "\e[31m$message\e[0m")" | tee -a "$LOGS/error.log" 1>&2
    exit 255
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
