FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

WORKDIR /home/vscode

# Install rsync for sync script
RUN apt-get update && apt-get install -y rsync && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/olets/zsh-test-runner.git /opt/zsh-test-runner && \
    echo 'source /opt/zsh-test-runner/zsh-test-runner.plugin.zsh' >> ~/.zshrc

COPY .devcontainer/post-create.sh /usr/src/
RUN chmod +x /usr/src/post-create.sh

# Copy everything from project root's zsh folder
COPY zsh /workspace/zsh

# Install sync script
COPY sync-configs /usr/local/bin/
RUN chmod +x /usr/local/bin/sync-configs

# Set default user (already exists in base image)
USER vscode