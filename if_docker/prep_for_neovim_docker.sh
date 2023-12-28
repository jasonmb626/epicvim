#!/bin/bash
cat ~/.config/nvim/if_docker/docker-compose.yml| sed "s/%UID%/$(id -u)/" | sed "s/%GID%/$(id -g)/" > $PWD/docker-compose.yml
cp ~/.config/nvim/if_docker/Dockerfile $PWD
touch $PWD/requirements.txt
touch $PWD/requirements-dev.txt
mkdir -p $PWD/app
