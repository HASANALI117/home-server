#!/bin/bash
source ../configs/config.env
source ./utilities.sh

manage_services() {
    check_dependencies

    # Get available services
    mapfile -t all_services < <(ls "$COMPOSE_FILES" | sed 's/\.yml$//')

    # Get current selections
    mapfile -t current_services < <(
        yq eval '.include[]' "$DOCKER_COMPOSE" |
            sed 's/^.*\///; s/\.yml$//'
    )

    # Prepare gum choices
    choices=()
    for service in "${all_services[@]}"; do
        status=$([[ " ${current_services[@]} " =~ " $service " ]] && echo "✓" || echo " ")
        choices+=("$status $service")
    done

    # Show interactive selector
    selected=$(gum choose --no-limit --cursor-prefix "[ ] " \
        --selected-prefix "[✓] " "${choices[@]}" | awk '{print $2}')

    # Update master compose
    yq -i 'del(.include)' "$DOCKER_COMPOSE"
    for service in $selected; do
        yq -i ".include += [\"compose/$service.yml\"]" "$DOCKER_COMPOSE"
    done

    # Deploy changes
    gum confirm "Apply changes?" && deploy_services
}

deploy_services() {
    gum spin --spinner dot --title "Deploying services..." -- \
        docker compose -f "$MASTER_COMPOSE" up -d
    gum style "Deployment complete!" --foreground="#00FF00"
}

# Entry point
case $1 in
--tui) manage_services ;;
*) echo "Usage: ./service-manager.sh --tui" ;;
esac
