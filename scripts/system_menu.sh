# System menu function
show_system_menu() {
    while true; do
        CHOICE=$(
            gum choose --header "System Configuration Menu" --height 15 \
                "Rclone & Mounting" \
                "Set Folders" \
                "Setup Bash Aliases" \
                "Back"
        )
        case "${CHOICE}" in
        'Rclone & Mounting')
            setup_rclone
            ;;
        'Set Folders')
            set_folders_menu
            ;;
        'Setup Bash Aliases')
            setup_bash_aliases
            ;;
        'Back')
            return
            ;;
        esac
    done
}

setup_rclone() {
    gum confirm "Install Rclone?" &&
        gum spin --spinner line --title "Installing Rclone..." -- \
            sudo apt-get install -y rclone &&
        success_msg "Rclone installed!" ||
        handle_error "Rclone installation failed"

    gum confirm "Configure Rclone?" && rclone config
}

set_folders_menu() {
    while true; do
        CHOICE=$(gum choose --header "Select Folder Type" --height 15 \
            "Downloads Folder" \
            "Media Folder 1" \
            "Media Folder 2" \
            "Media Folder 3" \
            "Books Folder" \
            "Back")

        case "${CHOICE}" in
        'Downloads Folder')
            set_directory "DOWNLOADS_DIR" "Select Downloads Directory"
            ;;
        'Media Folder 1')
            set_directory "MEDIA_DIR_1" "Select Media Directory 1"
            ;;
        'Media Folder 2')
            set_directory "MEDIA_DIR_2" "Select Media Directory 2"
            ;;
        'Media Folder 3')
            set_directory "MEDIA_DIR_3" "Select Media Directory 3"
            ;;
        'Books Folder')
            set_directory "BOOKS_DIR" "Select Books Directory"
            ;;
        'Back')
            return
            ;;
        esac
    done
}

set_directory() {
    local var_name=$1 header=$2
    local dir=$(gum file --directory --header "$header")
    if [ -n "$dir" ]; then
        mkdir -p "$dir" || handle_error "Failed to create directory"
        eval "$var_name=\"$dir\""
        save_config
        success_msg "$header set to $dir"
    fi
}

setup_bash_aliases() {
    local alias_file="$BASE_DIR/.aliases"
    [ -z "$BASE_DIR" ] && handle_error "Base directory not set" && return

    cat <<EOF >"$alias_file"
# Docker aliases
alias dc="docker compose"
alias dcd="docker compose down"
alias dcu="docker compose up -d"
alias dcl="docker compose logs -f"

# Navigation aliases
alias cdb="cd $BASE_DIR"
alias cddata="cd $BASE_DIR/data"
EOF

    if gum confirm "Add aliases to .bashrc?"; then
        echo "source $alias_file" >>"$HOME/.bashrc"
        success_msg "Aliases added to .bashrc"
    fi
}
