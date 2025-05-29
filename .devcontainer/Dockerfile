FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

WORKDIR /home/vscode

# Install rsync for sync script
RUN apt-get update && apt-get install -y rsync && rm -rf /var/lib/apt/lists/*

# Install shellspec from latest main branch into /usr/local/bin
RUN git clone https://github.com/shellspec/shellspec.git /opt/shellspec && \
    ln -s /opt/shellspec/shellspec /usr/local/bin/shellspec

COPY .devcontainer/post-create.sh /usr/src/
RUN chmod +x /usr/src/post-create.sh

# Copy everything from project root's zsh folder
# COPY zsh /workspace/zsh

# Install sync script
# COPY sync-configs /usr/local/bin/
# RUN chmod +x /usr/local/bin/sync-configs

# Set default user (already exists in base image)
USER vscode