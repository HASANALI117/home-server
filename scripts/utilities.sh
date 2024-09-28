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
