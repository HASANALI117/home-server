#!/bin/bash

# Configuration variables
USER=$(whoami)
USERDIR="/home/$USER"
DATADIR="/media/storage"
DOCKER_ROOT="$USERDIR/docker"
APPDATA="$DOCKER_ROOT/appdata"
COMPOSE="$DOCKER_ROOT/compose/$USER"
LOGS="$DOCKER_ROOT/logs"
SCRIPTS="$DOCKER_ROOT/scripts"
SECRETS="$DOCKER_ROOT/secrets"
SHARED="$DOCKER_ROOT/shared"
ENV_FILE="$DOCKER_ROOT/.env"
MASTER_COMPOSE="$DOCKER_ROOT/docker-compose-udms.yml"
ENV_EXAMPLE="../.env.example"
DOCKER_COMPOSE="../docker-compose-udms.yml"
HOMEPAGE_CONFIG="../configs/homepage/docker-configs"
QBITTORRENT_CONFIG="../configs/qbittorrent/qbittorrent.conf"
COMPOSE_FILES="../compose"
