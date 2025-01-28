#!/bin/bash

source ./prerequisites_menu.sh
source ./system_menu.sh
source ./docker_menu.sh
source ./security_menu.sh
source ./apps_menu.sh
source ./view_configuration.sh
source ./utilities.sh

# Main menu function
show_main_menu() {
    while true; do
        CHOICE=$(gum choose --header "Main Menu" --height 15 \
            '1. Prerequisites' \
            '2. System Configuration' \
            '3. Docker Setup' \
            '4. Security' \
            '5. Install Apps' \
            '6. View Configuration' \
            '7. Exit')

        case "${CHOICE}" in
        '1. Prerequisites')
            show_prerequisites_menu
            ;;
        '2. System Configuration')
            show_system_menu
            ;;
        '3. Docker Setup')
            show_docker_menu
            ;;
        '4. Security')
            show_security_menu
            ;;
        '5. Install Apps')
            show_apps_menu
            ;;
        '6. View Configuration')
            view_configuration
            ;;
        '7. Exit')
            gum confirm "Are you sure you want to exit?" && exit 0
            ;;
        esac
    done
}

main() {
    clear
    gum style \
        --foreground 212 --border-foreground 57 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
        "                  ##        .         " \
        "            ## ## ##       ==         " \
        "         ## ## ## ##      ===         " \
        "     /""""""""""""""""\___/ ===       " \
        "~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~" \
        "     \______ o          __/           " \
        "       \    \        __/              " \
        "        \____\______/                 " \
        "" \
        'Ultimate Docker Media Server'
    # "██╗   ██╗██████╗ ███╗   ███╗███████╗" \
    # "██║   ██║██╔══██╗████╗ ████║██╔════╝" \
    # "██║   ██║██║  ██║██╔████╔██║███████╗" \
    # "██║   ██║██║  ██║██║╚██╔╝██║╚════██║" \
    # "╚██████╔╝██████╔╝██║ ╚═╝ ██║███████║" \
    # "╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝ " \
    show_main_menu
}

main
