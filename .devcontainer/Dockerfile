FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

WORKDIR /home/vscode

# Install shellspec from latest main branch into /usr/local/bin
RUN git clone https://github.com/shellspec/shellspec.git /opt/shellspec && \
    ln -s /opt/shellspec/shellspec /usr/local/bin/shellspec

# A post-create script to run after the container is created
COPY .devcontainer/post-create.sh /usr/src/
RUN chmod +x /usr/src/post-create.sh

# Set default user (already exists in base image)
USER vscode