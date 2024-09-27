#!/bin/bash

# Configuration variables

# Directories
DATADIR="/media/storage"
DOCKER_ROOT="$HOME/docker"
APPDATA="$DOCKER_ROOT/appdata"
COMPOSE="$DOCKER_ROOT/compose"
LOGS="$DOCKER_ROOT/logs"
SCRIPTS="$DOCKER_ROOT/scripts"
SECRETS="$DOCKER_ROOT/secrets"
SHARED="$DOCKER_ROOT/shared"

# Environment and Compose files
ENV_FILE="$DOCKER_ROOT/.env"
MASTER_COMPOSE="$DOCKER_ROOT/master-compose.yml"
ENV_EXAMPLE="../.env.example"
DOCKER_COMPOSE="../master-compose.yml"

# Configuration files
HOMEPAGE_CONFIG="../configs/homepage/docker-configs"
QBITTORRENT_CONFIG="../configs/qbittorrent/qbittorrent.conf"
QBITTORRENT_CONF="$APPDATA/qbittorrent/qBittorrent/qBittorrent.conf"
DOCKERGC_EXCLUDE="../configs/docker-gc/docker-gc-exclude"
COMPOSE_FILES="../compose"

# Bash configuration
BASH_CONFIG="$SHARED/config/.bash_aliases"
BASHRC="$HOME/.bashrc"
BASH_ENV="$SHARED/config/bash_aliases.env"
