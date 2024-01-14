#!/bin/bash

if [[ ! -s ~/.ssh/docker_id_ed25519 ]]; then
  cp ~/.config/nvim/if_docker/docker_id_ed25519 ~/.ssh/docker_id_ed25519
  chown $(id -u):$(id -g) ~/.ssh/docker_id_ed25519
  chmod 600 ~/.ssh/docker_id_ed25519
fi
cp ~/.config/nvim/if_docker/Dockerfile $PWD
if [[ "$1" == "-R" ]]; then
  cat ~/.config/nvim/if_docker/docker-compose.yml| sed "s/%UID%/0/" | sed "s/%GID%/0/" > $PWD/docker-compose.yml
  sed -i 's,/home/app/,/root/,g' $PWD/docker-compose.yml
  sed -i 's,/home/app/,/root/,g' $PWD/Dockerfile
  sed -i 's/app:app/root:root/g' $PWD/Dockerfile
else
  cat ~/.config/nvim/if_docker/docker-compose.yml| sed "s/%UID%/$(id -u)/" | sed "s/%GID%/$(id -g)/" > $PWD/docker-compose.yml
fi
touch $PWD/requirements.txt
touch $PWD/requirements-dev.txt
mkdir -p $PWD/app
