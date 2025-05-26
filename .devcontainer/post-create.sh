#!/usr/bin/env zsh

# Set up SSH manager
sudo mkdir -p ~/.ssh && \
sudo cp ~/.ssh/contexts/${SSH_CONTEXT}/config ~/.ssh/config && \
sudo chown -R ${USER}:${USER} ~/.ssh