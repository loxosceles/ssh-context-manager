# SSH Context Manager

A simple tool for managing multiple SSH configurations using context files.
Designed for use in dev containers and Linux environments and written in shell
script, no dependencies required (other than the test runner `shellspec`).

## Core Features

1. **Host Machine Context Switching**
    - Switch between different SSH contexts (work, personal, projects) on your host machine.
    - Each context maintains its own isolated keys and configuration—no risk of
    accidental cross-context leaks.  
    - Quickly switch active SSH configuration
    - Create and manage multiple SSH contexts with ease.
    - Backup SSH configurations for different contexts.

2. **Devcontainer Integration**
    - Mount only the active SSH context into your VSCode devcontainer, ensuring
    the correct keys are available.  
    - Isolates development environments—containers never see unrelated keys,
    keeping projects secure and clean.

## Usage

- Switch contexts by changing the `SSH_CONTEXT` variable and re-running the script.
- Your active SSH config will be updated in `~/.ssh/config`.

## Run the Tests

To run the tests, run the following command in your terminal: 

```bash
    shellspec -s zsh
```

The shellspec executable is already included in the devcontainer, so you can run
it directly.

## Development

- Contributions are welcome! Please open issues or pull requests.

### Development Setup

1. Clone this repository:
    ```bash
    git clone https://github.com/your-username/ssh-context-manager.git
    cd ssh-context-manager
    ```

2. Build or open in a devcontainer from the `.devcontainer` directory:

3. Put some sample SSH context configs in `~/.ssh/contexts/`. A context is
basically a regular SSH configuration with different keys and a config file.  
Example structure:
   ```
   ~/.ssh/contexts/
       ├── config 
       ├── personal/
       │   ├── id_rsa
       │   ├── id_rsa.pub
       │   └── config
       └── work/
           ├── id_ed25519
           ├── id_ed25519.pub
           └── config
   ```

4. Activate the context by running:
    ```bash
    sync-configs --sync 
    exec zsh
    ```
    This step will backup the default ZSH config (`~/.zshrc`) to `/tmp` and copy
    the context-specific ZSH config to `~/.zshrc`. After that, you need to open
    a new zsh or run `exec zsh` to apply the changes. Now you should have access
    to the zsh command `ssh-context` and other commands (documented below).

## Command Reference

### Basic Usage
```sh
ssh-context [<context-name>] [options]
```

### Commands

#### Show current context
```sh
ssh-context
```
Displays the currently active SSH context.

#### Switch context
```sh
ssh-context <context-name>
# Example: ssh-context work
```

#### List available contexts
```sh
ssh-context --list
# or
ssh-context -l
```

#### Generate new context template
```sh
ssh-context --generate <name>
# or
ssh-context -g <name>

# Example: ssh-context -g company-a 
```

#### Show help
```sh
ssh-context --help
# or
ssh-context -h
```

### Examples

**1. List all contexts and switch:**
```sh
ssh-context -l
ssh-context personal
```

**2. Create and activate new context:**
```sh
ssh-context --generate client-project
ssh-context client-project
```

### Context Structure
Each context maintains its own directory with:
- SSH keys (`id_rsa`, `id_ed25519`, etc.)
- Custom `config` file
- Automatic backups when modified

Default location:
```
~/.ssh/contexts/
   ├── personal/
   │   ├── id_rsa
   │   ├── id_rsa.pub
   │   └── config
   └── work/
       └── ...
```

> Note: Contexts are automatically detected from subdirectories in `~/.ssh/contexts/`

## License

MIT License
