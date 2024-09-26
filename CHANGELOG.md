### **v1.3.0**

- **Added**: `print_intro`and `print_setup_complete` functions to improve clarity and UX.
- **Rename**: `docker-udms.sh` to `udms.sh` and `docker-compose-udms.yml` to `master-compose.yml`.
- **Refactor**: `USERDIR` variable handling in `create_env_file` function. Compose file paths and config variables.

### **v1.2.0**

- **Added**: Support for Bash aliases in the setup, along with the `BASH-ALIASES.md` file to document the new aliases.
- **Refactor**: Updated `docker-compose` file to include the Jellyfin service and updated `set_permissions` to set Jellyfin directory permissions.
- **Fix**: Resolved directory issues in `download_docker_gc_exclude` and `edit_homepage_config` functions.
- **Update**: Enhanced `README.md` with new installation steps and additional documentation improvements.

### **v1.1.0**

- **Modularize**: Separated helper functions and configuration scripts.
- **Refactor**: Improved handling of environment variables (`create_env_file`, `edit_homepage_config`).

### **v1.0.0**

**(Initial Release)**

- **Initial Commit**: Basic setup of Docker Compose files for services like Plex, Jellyfin, and more.
- **Added**: Master Docker Compose file and `.env.example` for environment variable management.
- **Implemented**: Basic setup script for Docker, using `sudo docker compose`.
