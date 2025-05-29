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

## Quick Start

### Pre-requisites

1. Backup your current SSH config:

    ```zsh
    cp -R ~/.ssh ~/.ssh_bak
    ```
1. Create a new context directory:

    ```zsh
    # For the sake of this introduction, I'll assume here that you name your
    # private context "personal", for the purpose of storing your personal SSH
    # keys.

    mkdir -p ~/.ssh/contexts/personal
    ```
1. If you want to try context switching, you can repeat the previous step to
   create another context, e.g. `work`:

    ```zsh
    mkdir -p ~/.ssh/contexts/work
    ```
    Use your exsiting keys or start from scratch and generate new SSH keys for
    each context: 

    ```zsh

    # Replace the email address(es) with your own here
    ssh-keygen -t ed25519 -f ~/.ssh/contexts/personal/id_ed25519 -C "you@developer.me"

    # Optionally:
    # ssh-keygen -t ed25519 -f ~/.ssh/contexts/work/id_ed25519 -C "you@my-company.com"
    ```
1. Create a SSH config file for each context:

    ```zsh
    # For personal context
    USERNAME="your-username"  # Replace with your actual username on the server/ service
    echo -e "Host personal\n  HostName localhost\n  User ${USERNAME}\n  IdentityFile ~/.ssh/contexts/personal/id_ed25519" > ~/.ssh/contexts/personal/config

    # For work context
    # echo -e "Host work\n  HostName localhost\n  User ${USERNAME}\n  IdentityFile ~/.ssh/contexts/work/id_ed25519" > ~/.ssh/contexts/work/config
    ```

After this initial setup, you can start using the SSH Context Manager in one of
the following scenarios:

1. **On Host Machine Environment**
1. **In VSCode devcontainer Environment**

### On Host Machine Environment

1. Make sure that you have followed the pre-requisites above and have
   created at least one context (e.g. `personal`).
1. Open a terminal and run the followings command to activate the SSH context manager:

    ```zsh
    mkdir -p ~/.config/zsh && cp -R ssh.zsh ~/.config/zsh &&
    cp ~/.zshrc ~/.zshrc.original && 
    echo "source ~/.config/zsh/ssh.zsh" >> ~/.zshrc &&
    exec zsh
    ```
    This will copy the context-specific SSH config to `~/.ssh/config` and backup
    your original `.zshrc` file to `~/.zshrc.original`. Lastely, the running
    `.zshrc` configuration will now source the SSH context manager script once
    we reloaded the zsh by means of the `exec` command. You can check this for
    yourself by running:

    ```zsh
    cat ~/.zshrc
    ```
    and scroll to the bottom of the file.
1. You can now use the `ssh-context` commands to switch between contexts,
    list available contexts, or generate new content templates. You might want
    to experiment with the SSH context manager inside the devcontainer first,
    read the documentation below specific commands, these are applicable on the
    host as well.

    > **⚠️ IMPORTANT:**  
    > Note that the main difference between the host machine and the devcontainer
    > environment is that in the devcontainer, you will mount a specific context
    > into the container, which is editible via the tool. Any other contexts you
    > create are not automatically persisted or written into you host machine's
    > `~/.ssh/contexts/` directory. This gives you the opportunity to toy with
    > differnt contexts without affecting your host machine's SSH configuration,
    > with the exception of the context you mounted into the devcontainer.
    >
    > In turn, on the host machine, all contexts are editable and they are
    > persisted.
    
    
### In VSCode devcontainer Environment

1. Make sure that you have followed the pre-requisites above and have
   created at least one context (e.g. `personal`).

1. Use any editor to open the `.devcontainer.json` file inside the
`.devcontainer` directory of the `ssh-context-manager` repository. Make sure
that the `containerEnv` section includes the `SSH_CONTEXT` variable set to your
desired context, e.g.:

    ```json
    "containerEnv": {
        "SSH_CONTEXT": "personal"
    }
    ```
    if you named your context differently, replace `personal` with the name of
    the context you want to mount into the devcontainer. 

    > **⚠️ IMPORTANT:**  
    > Whatever context you mount, be aware that this context will be editable via the tool.  
    > Any edits will be reflected in your host machine's `~/.ssh/contexts/<context-name>/` directory.  
    > **Do not mount a context you do not want to edit.**
1. Open the ssh-context-manager repository in VSCode. Make sure that you have
    the [DevContainers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed. You should be prompted to reopen the repository in a devcontainer.  Click on "Reopen in Container". If you do this for the first time, it will take a few minutes to build the devcontainer image and set up the environment.  
1.  Once the devcontainer is up and running, open a terminal in VSCode and run
the followings command to activate the SSH context manager: 

    ```zsh
    mkdir -p ~/.config/zsh && cp -R ssh.zsh ~/.config/zsh &&
    cp ~/.zshrc ~/.zshrc.original && 
    echo "source ~/.config/zsh/ssh.zsh" >> ~/.zshrc &&
    exec zsh
    ```
    This will copy the context-specific SSH config to `~/.ssh/config` and backup
    your original `.zshrc` file to `~/.zshrc.original`. Lastely, the running
    `.zshrc` configuration will now source the SSH context manager script once
    we reloaded the zsh by means of the `exec` command. You can check this for
    yourself by running:

    ```zsh
    cat ~/.zshrc
    ```
    and scroll to the bottom of the file.   
1. You can now use the
    `ssh-context` commands to switch between contexts, list available contexts,
    or generate new context templates. 
    
    To list all available contexts, run:

    ```zsh
    ssh-context --list
    ```

    To generate a new context template, run:

    ```zsh
    ssh-context --generate new-context-name
    ```
    This will print the instructions you need to follow first, such as creating
    the context directory and SSH keys. This is intentionally kept as a manual
    step to ensure you have control over the key creation process.

    If the context is not yet created, this is what you will see:

    ```text
    Error: Context directory '/home/vscode/.ssh/contexts/new-context-name' doesn't exist.

    To create a new context:
    1. Create the context directory:
    mkdir -p /home/vscode/.ssh/contexts/new-context-name

    2. Add your SSH keys to the directory:
    cp /path/to/your/key /home/vscode/.ssh/contexts/new-context-name/id_rsa
    cp /path/to/your/key.pub /home/vscode/.ssh/contexts/new-context-name/id_rsa.pub

    3. Run this command again:
    ssh-context --generate new-context-name

1. Switch to the the `new-context-name` context, run: 

    ```zsh
    # Per default, you will be in the context which you originally set in the
    # `.devcontainer.json` file.

    ssh-context new-context-name 
    ```
1. Try connecting to a host using the new context:

    ```zsh
    ssh my-configured-server # or whatever you used in your SSH config's host configuration
    ```
1. If you want to persist a newly created context, you will need to do this
manually by copying the context directory to your host machine's
`~/.ssh/contexts/` directory.  

**NOTE:** A great usecase is to set up two different GitHub accounts
(e.g. one for work and one for personal projects). You can create two contexts
with a config similar to this:

```text
# ~/.ssh/contexts/personal/config

Host github
  HostName github.com
  User private-git-user-name 
  IdentityFile ~/.ssh/contexts/personal/id_ed25519

# ~/.ssh/contexts/work/config
Host github
  HostName github.com
  User work-git-user-name 
  IdentityFile ~/.ssh/contexts/work/id_ed25519
```

Then you can clone repositories using the respective context:

```zsh
ssh-context personal && ssh -T github
# Will output:
# Hi private-git-user-name! You've successfully authenticated, but GitHub does not provide shell access.

ssh-context work && ssh -T github
# Will output:
# Hi work-git-user-name! You've successfully authenticated, but GitHub does not provide shell access.
```

## How it Works

The environment variable `SSH_CONTEXT` is used to determine the active SSH
context. The SSH context manager will will use this variable to determine
the active context and keep it in sync. The base config file in the `$HOME/.ssh`
root folder will be automatically updated to include to the active context's
`~/.ssh/contexts/<context-name>/config` file. This file should not be edited. 

## Run the Tests

To run the tests, run the following command in your terminal: 

```zsh
    shellspec -s zsh
```

The shellspec executable is already included in the devcontainer, so you can run
it directly.

## Uninstall
To uninstall the SSH Context Manager, simply remove the sourced line from your
`.zshrc` file and delete the `ssh.zsh` script:

```zsh
sed -i '/source ~\/\.config\/zsh\/ssh\.zsh/d' ~/.zshrc
rm ~/.config/zsh/ssh.zsh && rmdir ~/.config/zsh 2>/dev/null
```


## Command Reference

### Basic Usage

```zsh
ssh-context [<context-name>] [options]
```

### Commands

#### Show current context

```zsh
ssh-context
```
Displays the currently active SSH context.

#### Switch context

```zsh
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

## Contributing  

This is a small project, but feedback and contributions are welcome!  

- **Bug reports**: Open an [issue]( https://github.com/loxosceles/ssh-context-manager/issues) with details.  
- **Suggestions**: Feel free to discuss ideas in issues.  
- **Code**: Fork the repo, make changes, and submit a pull request.  

Keep it simple and focused. Thanks for helping out! 

## License

[MIT License](./LICENSE)
