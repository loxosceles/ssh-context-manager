#!/usr/bin/env zsh

# These commands run after the container is created, but before it is started. As opposed to
# the Dockerfile, it will run under the user specified in devcontainer.json, not as root.
# Feel free to add any additional setup commands here.

# Set correct permission of the mounted .ssh directory since it was created by
# root
sudo chown -R ${USER}:${USER} ~/.ssh