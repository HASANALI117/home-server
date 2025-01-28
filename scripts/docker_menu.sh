source ./utilities.sh

# Docker Setup menu
show_docker_menu() {
    while true; do
        CHOICE=$(gum choose --header "Docker Options Menu" --height 15 \
            "Setup Socket Proxy" \
            "Deploy Homepage Dashboard" \
            "Back")

        case "${CHOICE}" in
        'Setup Socket Proxy')
            setup_socket_proxy
            ;;
        'Deploy Homepage Dashboard')
            deploy_homepage
            ;;
        'Back')
            return
            ;;
        esac
    done
}

setup_socket_proxy() {
    [ -z "$BASE_DIR" ] && handle_error "Base directory not set" && return

    cat <<EOF >"$BASE_DIR/compose/socket-proxy.yml"
version: '3'
services:
  socket-proxy:
    image: tecnativa/docker-socket-proxy
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    ports:
      - "2375:2375"
    environment:
      - CONTAINERS=1
EOF

    gum spin --spinner line --title "Starting Socket Proxy..." -- \
        docker compose -f "$BASE_DIR/compose/socket-proxy.yml" up -d &&
        success_msg "Socket proxy deployed!" ||
        handle_error "Failed to deploy socket proxy"
}

deploy_homepage() {
    [ -z "$BASE_DIR" ] && handle_error "Base directory not set" && return

    local config_dir="$BASE_DIR/configs/homepage"
    mkdir -p "$config_dir"

    cat <<EOF >"$config_dir/docker-compose.yml"
version: '3'
services:
  homepage:
    image: ghcr.io/benphelps/homepage:latest
    restart: unless-stopped
    ports:
      - "3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - $config_dir:/app/config
EOF

    gum spin --spinner line --title "Deploying Homepage..." -- \
        docker compose -f "$config_dir/docker-compose.yml" up -d &&
        success_msg "Homepage deployed!" ||
        handle_error "Failed to deploy homepage"
}
