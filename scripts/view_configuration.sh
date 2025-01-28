# View current configuration
view_configuration() {
    gum style --border double --padding "1 2" --margin 1 --border-foreground 57 \
        "Current Configuration:" \
        "Base Directory: ${BASE_DIR:-Not set}" \
        "Server IP: ${SERVER_IP:-Not set}" \
        "Timezone: ${TIMEZONE:-Not set}" \
        "Downloads Dir: ${DOWNLOADS_DIR:-Not set}" \
        "Media Dir 1: ${MEDIA_DIR_1:-Not set}" \
        "Media Dir 2: ${MEDIA_DIR_2:-Not set}" \
        "Media Dir 3: ${MEDIA_DIR_3:-Not set}" \
        "Books Dir: ${BOOKS_DIR:-Not set}"
    read -n 1 -s -r -p "Press any key to continue..."
}
