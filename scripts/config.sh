#!/bin/bash

# Configuration variables
DATADIR="/media/storage"
DOCKER_ROOT="$HOME/docker"
APPDATA="$DOCKER_ROOT/appdata"
COMPOSE="$DOCKER_ROOT/compose/$HOSTNAME"
LOGS="$DOCKER_ROOT/logs"
SCRIPTS="$DOCKER_ROOT/scripts"
SECRETS="$DOCKER_ROOT/secrets"
SHARED="$DOCKER_ROOT/shared"
ENV_FILE="$DOCKER_ROOT/.env"
MASTER_COMPOSE="$DOCKER_ROOT/docker-compose-$HOSTNAME.yml"
ENV_EXAMPLE="../.env.example"
DOCKER_COMPOSE="../docker-compose-udms.yml"
HOMEPAGE_CONFIG="../configs/homepage/docker-configs"
QBITTORRENT_CONFIG="../configs/qbittorrent/qbittorrent.conf"
QBITTORRENT_CONF="$APPDATA/qbittorrent/qBittorrent/qBittorrent.conf"
DOCKERGC_EXCLUDE="../configs/docker-gc/docker-gc-exclude"
COMPOSE_FILES="../compose"
BASH_CONFIG="$HOME/.bash_aliases"
BASHRC="$HOME/.bashrc"
BASH_ENV="$SHARED/config/bash_aliases.env"
