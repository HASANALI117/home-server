source ./utilities.sh

# Security menu
show_security_menu() {
    while true; do
        CHOICE=$(gum choose --header "Security Menu" --height 15 \
            "Setup Authelia" \
            "Setup Google OAuth" \
            "Back")

        case "${CHOICE}" in
        'Setup Authelia')
            setup_authelia
            ;;
        'Setup Google OAuth')
            setup_google_oauth
            ;;
        'Back')
            return
            ;;
        esac
    done
}

setup_authelia() {
    [ -z "$BASE_DIR" ] && handle_error "Base directory not set" && return

    local authelia_dir="$BASE_DIR/configs/authelia"
    mkdir -p "$authelia_dir"

    # Generate secrets
    local jwt_secret=$(openssl rand -hex 32)
    local storage_encryption_key=$(openssl rand -hex 32)
    local session_secret=$(openssl rand -hex 32)

    # Create configuration
    cat <<EOF >"$authelia_dir/configuration.yml"
theme: dark
jwt_secret: $jwt_secret
storage:
  encryption_key: $storage_encryption_key
  local:
    path: /config/db.sqlite3
session:
  secret: $session_secret
  domain: yourdomain.com
authentication_backend:
  disable_reset_password: false
access_control:
  default_policy: deny
EOF

    success_msg "Authelia configuration created. Edit $authelia_dir/configuration.yml before deployment."
}

setup_google_oauth() {
    gum style --foreground 57 "Follow these steps to configure Google OAuth:"
    gum style --margin "1 2" "1. Create OAuth credentials at https://console.cloud.google.com"
    gum style --margin "1 2" "2. Add authorized redirect URI: https://yourdomain.com/oauth2/callback"
    local client_id=$(gum input --placeholder "Enter Client ID")
    local client_secret=$(gum input --placeholder "Enter Client Secret" --password)

    [ -z "$client_id" ] || [ -z "$client_secret" ] && handle_error "Invalid credentials" && return

    gum style --foreground 57 "Google OAuth credentials received. Use these in your application configurations."
}
