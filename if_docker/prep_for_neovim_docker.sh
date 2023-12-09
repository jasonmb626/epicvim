#!/bin/bash

cp ~/.config/nvim/if_docker/docker-compose.yml $PWD
cp ~/.config/nvim/if_docker/Dockerfile $PWD
touch $PWD/requirements.txt
touch $PWD/requirements-dev.txt
mkdir -p $PWD/app
