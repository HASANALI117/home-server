source ./utilities.sh

# Prerequisites menu
show_prerequisites_menu() {
    while true; do
        CHOICE=$(gum choose --header "Prerequisites Menu" --height 15 \
            "Install Base Packages" \
            "Install Docker" \
            "Set Base Directory" \
            "Configure Timezone" \
            "Setup Docker Environment" \
            "Set Server IP" \
            "Back")

        case "${CHOICE}" in
        'Install Base Packages')
            install_base_packages
            ;;
        'Install Docker')
            install_docker
            ;;
        'Set Base Directory')
            set_base_directory
            ;;
        'Configure Timezone')
            set_timezone
            ;;
        'Setup Docker Environment')
            setup_docker_environment
            ;;
        'Set Server IP')
            set_server_ip
            ;;
        'Back')
            return
            ;;
        esac
    done
}

install_base_packages() {
    gum spin --spinner line --title "Installing dependencies..." -- \
        sudo apt-get update && sudo apt-get install -y curl jq yq acl &&
        success_msg "Base packages installed!" ||
        handle_error "Failed to install base packages"
}

install_docker() {
    gum spin --spinner line --title "Installing Docker..." -- \
        curl -fsSL https://get.docker.com | sudo sh &&
        sudo usermod -aG docker $USER &&
        sudo systemctl enable docker &&
        success_msg "Docker installed and configured!" ||
        handle_error "Docker installation failed"

    gum style --foreground 57 "You may need to log out and back in for group changes to take effect."
}

set_base_directory() {
    local dir
    dir=$(gum input --placeholder "/opt/docker" --prompt "📁 Base path: " --value "$BASE_DIR")
    if [ -n "$dir" ]; then
        mkdir -p "$dir" || handle_error "Failed to create directory"
        BASE_DIR="$dir"
        save_config
        success_msg "Base directory set to $BASE_DIR"
    fi
}

set_timezone() {
    local tz
    tz=$(timedatectl list-timezones | gum filter --placeholder "Select timezone" --value "$TIMEZONE")
    if [ -n "$tz" ]; then
        sudo timedatectl set-timezone "$tz" &&
            TIMEZONE="$tz" &&
            save_config &&
            success_msg "Timezone set to $tz" ||
            handle_error "Failed to set timezone"
    fi
}

setup_docker_environment() {
    [ -z "$BASE_DIR" ] && handle_error "Base directory not set" && return

    gum spin --spinner line --title "Creating Docker structure..." -- \
        mkdir -p "$BASE_DIR"/{compose,configs,data,scripts,backups} &&
        success_msg "Docker environment created in $BASE_DIR" ||
        handle_error "Failed to create directory structure"
}

set_server_ip() {
    local ip
    ip=$(gum input --placeholder "192.168.x.x" --prompt "🔌 Server IP: " --value "$SERVER_IP")
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        SERVER_IP="$ip"
        save_config
        success_msg "Server IP set to $ip"
    else
        handle_error "Invalid IP address format"
    fi
}
