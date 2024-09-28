#!/bin/bash

# Source configuration file
source ../configs/config.env
source ./utilities.sh

# Add Docker aliases to bash configuration
add_docker_aliases() { 
    echo -e "\e[36m"
    typing_print "================================================"
    typing_print "  Step 4: Adding Docker aliases...              "
    typing_print "================================================"
    echo -e "\e[0m"
    
    # Copy bash_aliases.env.example to $BASH_ENV
    if [[ -f "$BASH_ENV_EXAMPLE" ]]; then
        mkdir -p "$SHARED/config"
        cp "$BASH_ENV_EXAMPLE" "$BASH_ENV"
        done_msg "Created $BASH_ENV."
    else
        error_exit "bash_aliases.env.example file not found."
    fi

    # Add variables to bash_aliases.env file
    cat "../configs/config.env" >> "$BASH_ENV"

    # Check if bash_aliases file exists in the same directory as the script
    if [[ -f "../configs/bash_aliases" ]]; then
        # Copy the bash_aliases file to the bash configuration
        cp "../configs/bash_aliases" "$BASH_CONFIG"
        done_msg "Docker aliases added to $BASH_CONFIG."
    else
        error_exit "bash_aliases file not found."
    fi

    # Ensure .bashrc sources .bash_aliases
    if ! grep -q "source $BASH_CONFIG" "$BASHRC"; then
        echo "source $BASH_CONFIG" >> "$BASHRC"
        done_msg "Added 'source $BASH_CONFIG' to $BASHRC to load .bash_aliases."
    else
        typing_print "$BASHRC already sources $BASH_CONFIG."
    fi

    # Source the .bashrc to apply changes immediately
    source "$BASHRC"
}
