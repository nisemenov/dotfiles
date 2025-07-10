#!/bin/bash

set -e  # остановка при ошибке

cd ~/Dev/docker || exit 1

docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml build
docker compose -f docker-compose.yml up -d
