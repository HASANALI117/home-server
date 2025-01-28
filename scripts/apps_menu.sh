source ./utilities.sh

# Apps menu
show_apps_menu() {
    SERVICES_DIR="../compose"

    while true; do
        services=$(ls "$SERVICES_DIR" | gum choose --no-limit --height 25 --header "Select services to deploy (SPACE to select)")
        [ -z "$services" ] && break

        for service in $services; do
            gum spin --spinner line --title "Deploying $service..." -- \
                docker compose -f "$SERVICES_DIR/$service" up -d &&
                success_msg "$service deployed!" ||
                handle_error "Failed to deploy $service"
        done
    done
}
