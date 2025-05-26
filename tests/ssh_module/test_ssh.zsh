#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

source "${0:a:h}/../../zsh/modules/ssh.zsh" # Source your plugin

TEST_description="SSH Module Tests"

# ---- Fixture Setup ----
setup() {
    export FIXTURE_DIR="$(mktemp -d)"

    # Regular user structure
    mkdir -p "$FIXTURE_DIR/home_user/.ssh/contexts/{personal,work}"
    touch "$FIXTURE_DIR/home_user/.ssh/contexts/personal/config"

    # Devcontainer structure
    mkdir -p "$FIXTURE_DIR/devcontainer/home/vscode/.ssh/contexts"
}

teardown() {
    rm -rf "$FIXTURE_DIR"
}

# ---- Helper Functions ----
mock_whoami() {
    function whoami() {
        echo "$1"
    }

    mock_container_env() {
        touch /.dockerenv
        export DEV_CONTAINER_USER="vscode"
    }

    # ---- Core Tests ----
    TEST_case "__get_ssh_root detects environments correctly" {
    # Regular user
    (
        export HOME="$FIXTURE_DIR/home_user"
        mock_whoami "regularuser"
        [[ $(__get_ssh_root) == "$HOME/.ssh" ]]
    )

    # Devcontainer user
    (
        export HOME="$FIXTURE_DIR/devcontainer/home/vscode"
        mock_whoami "vscode"
        [[ $(__get_ssh_root) == "$HOME/.ssh" ]]
    )
}

TEST_case "ssh-context switches and persists config"
{
    local ssh_root="$FIXTURE_DIR/home_user/.ssh"
    (
        export HOME="$FIXTURE_DIR/home_user"

        # Test context switching
        ssh-context work >/dev/null
        [[ $SSH_CONTEXT == "work" ]]
        grep -q "Include.*work/config" "$ssh_root/config"

        # Verify persistence
        source "${0:a:h}/../../zsh/modules/ssh.zsh"
        [[ $SSH_CONTEXT == "work" ]]
    )
}

TEST_case "__generate_context_config creates valid templates"
{
    (
        export HOME="$FIXTURE_DIR/home_user"
        mkdir -p "$HOME/.ssh/contexts/newcontext"

        __generate_context_config "newcontext"
        [[ -f "$HOME/.ssh/contexts/newcontext/config" ]]
        grep -q "CONTEXT: newcontext" "$HOME/.ssh/contexts/newcontext/config"
    )
}

TEST_case "Container detection safety"
{
    # Should disable plugin in containers by default
    (
        mock_container_env
        unset ENABLE_SSH_CONTEXT
        source "${0:a:h}/../../zsh/modules/ssh.zsh" 2>&1 | grep -q "disabled in container"
        [[ $? -eq 0 ]]
        ! typeset -f ssh-context >/dev/null # Verify functions aren't loaded
    )

    # Should allow override
    (
        mock_container_env
        export ENABLE_SSH_CONTEXT=1
        source "${0:a:h}/../../zsh/modules/ssh.zsh"
        typeset -f ssh-context >/dev/null # Verify functions are loaded
    )
}
