## Table of Contents

- [How can I have different groups of tasks for different hosts with different configurations?](#how-can-i-have-different-groups-of-tasks-for-different-hosts-with-different-configurations)
- [Automatically install or update dotfiles when ssh'ing into a remote machine (or: let my dotfiles follow me)](#automatically-install-or-update-dotfiles-when-sshing-into-a-remote-machine-or-let-my-dotfiles-follow-me)
- [Automatically update your Dotbot config file when you add files in Git](#automatically-update-your-dotbot-config-file-when-you-add-files-in-git)

## How can I have different groups of tasks for different hosts with different configurations?

### Simple setup

See [here](https://github.com/anishathalye/dotbot/pull/11#issuecomment-73082152) for information on using machine-specific configs.

### More advanced setup

If you want to install programs independently from a general configuration file, the following setup might be for you. An advanced quickstart can be found at the [ecarlson94/dotbot-template Wiki](https://github.com/ecarlson94/dotbot-template/wiki).

#### Configurations
Write a configuration file for each program and put them together in a directory:
```
meta/configs/
├── bash.yaml
├── git.yaml
├── i3.yaml
└── ...
```
Then add a basic configuration file (i.e. for cleaning up) at `meta/base.yaml`.

#### Profiles
Then summarize these configurations in profiles:
```
meta/profiles/
├── server
├── workstation
└── ...
```
In a profile you specify the configurations you want to install (one per line, without `.yaml`).

#### New `install` scripts

Then replace the `install` script with the following ones. **Note that these scripts depend on the `dotbot` submodule being located in `meta/dotbot`, which differs from the setup described in the Dotbot README.** If you want to move the submodule from your repository root into the `meta/` directory, you can run `mkdir meta && git mv dotbot meta/dotbot`.

##### `install-profile`
```bash
#!/usr/bin/env bash

set -e

BASE_CONFIG="base"
CONFIG_SUFFIX=".yaml"

META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


cd "${BASE_DIR}"
git -C "${BASE_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${BASE_DIR}"


while IFS= read -r config; do
    CONFIGS+=" ${config}"
done < "${META_DIR}/${PROFILES_DIR}/$1"

shift

for config in ${CONFIGS} ${@}; do
    echo -e "\nConfigure $config"
    # create temporary file
    configFile="$(mktemp)"
    suffix="-sudo"
    echo -e "$(<"${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}")\n$(<"${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config%"$suffix"}${CONFIG_SUFFIX}")" > "$configFile"

    cmd=("${BASE_DIR}/${META_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$configFile")

    if [[ $config == *"sudo"* ]]; then
        cmd=(sudo "${cmd[@]}")
    fi

    "${cmd[@]}"
    rm -f "$configFile"
done

cd "${BASE_DIR}"
```

##### `install-standalone`
```bash
#!/usr/bin/env bash

set -e

BASE_CONFIG="base"
CONFIG_SUFFIX=".yaml"

META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


cd "${BASE_DIR}"
git submodule update --init --recursive --remote

for config in ${@}; do
    # create temporary file
    configFile="$(mktemp)"
    suffix="-sudo"
    echo -e "$(<"${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}")\n$(<"${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config%"$suffix"}${CONFIG_SUFFIX}")" > "$configFile"

    cmd=("${BASE_DIR}/${META_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" -c "$configFile")

    if [[ $config == *"sudo"* ]]; then
        cmd=(sudo "${cmd[@]}")
    fi

    "${cmd[@]}"
    rm -f "$configFile"
done

cd "${BASE_DIR}"
```

Now you should be able to install a profile with
```bash
./install-profile <profile> [<configs...>]
```
and single configurations with
```bash
./install-standalone <configs...>
```
You can also invoke a single configuration as a sudoer by adding `-sudo` to the end of a configuration
```bash
./install-standalone some-config-sudo some-other-config
```
In the last example, the `some-config` config will be run with elevated privileges, but `some-other-config` will not.

The above prevent passing command-line arguments like `-v` and `-q` to the Dotbot invocation. If you want to use command-line options in conjunction with the above, you can add parsing of command-line options as described in [#87](https://github.com/anishathalye/dotbot/issues/87#issue-146431889).

If you have any open questions or something is unclear, you can try to take a look at a dotfiles repository that uses this setup:
* [vbrandl/dotfiles](https://github.com/vbrandl/dotfiles)
* [vsund/dotfiles](https://github.com/vsund/dotfiles)
* [magicmonty/dotfiles_dotbot](https://github.com/magicmonty/dotfiles_dotbot)
* [vbriand/dotfiles](https://github.com/vbriand/dotfiles)

## Automatically install or update dotfiles when ssh'ing into a remote machine (or: let my dotfiles follow me)

Original inspiration: http://klaig.blogspot.co.at/2013/04/make-your-dotfiles-follow-you.html

In your local `~/.ssh/config`:

```
Host some.remote.host.example.com
    PermitLocalCommand yes
    # Unfortunately ssh does not support line breaks in config files
    LocalCommand ssh -o PermitLocalCommand=no %n "which git >/dev/null && ([[ -d ~/dotfiles ]] && (echo "Updating dotfiles on %h ..." && cd ~/dotfiles && git pull -q && ./install >/dev/null) || (echo "Installing dotfiles on %h ..." && git clone -q https://github.com/MYNAMESPACE/dotfiles && ./dotfiles/install >/dev/null))"
```

Relevant part broken down for readability:

```bash
LocalCommand ssh -o PermitLocalCommand=no %n "which git >/dev/null && ([[ -d ~/dotfiles ]] && \
  (echo "Updating dotfiles on %h ..." && cd ~/dotfiles && git pull -q && ./install >/dev/null) || \
  (echo "Installing dotfiles on %h ..." && git clone -q https://github.com/MYNAMESPACE/dotfiles && ./dotfiles/install >/dev/null))"
```

The main attraction here is the clever use of `LocalCommand`:

> `LocalCommand` Specifies a command to execute on the *local* machine after successfully connecting to the server.

We use `LocalCommand` to run a *second* SSH session to connect to the same remote machine and execute the defined command line in that SSH session. So what happens is this:

1. Initiate SSH connection to remote machine (`ssh user@some.remote.host.example.com`)
2. If the connection is successful (including authentication) then `LocalCommand` is executed
3. The `LocalCommand` initiates a second SSH connection to the same remote machine and executes the command line specified. This commandline updates or installes the dotfiles.

   The second SSH connection sets `-o PermitLocalCommand=no` so that *no local command* is executed for that SSH connection. Without this setting each SSH connection would initiate another SSH connection, which would initiate another SSH connection, ad infinitum. Wo don't want that.
4. When the command line of the second SSH connection is finished then the `LocalCommand` is finished
5. The initial SSH session is finally established and the remote shell becomes available

The command line is in Bash syntax so adapt it if you use a different shell.

First we check if `git` is even available (if it is not then nothing more will happen). Then, if there is a `dotfiles` directory in the user's home we `cd` into it, run `git pull` and `install`, thus updating the local dotfiles repository and installing any new or changed files or symlinks.

If there isn't a `dotfiles` repository in the user's home we do a fresh installation by cloning the dotfiles repo from Github and running the `install` command.

Obviously this `LocalCommand` is executed every time you connect to the remote machine so it will take a few seconds before your remote shell becomes available.

This works best if you use public key authentication (or GSSAPI/Kerberos authentication) so SSH doesn't ask for a password when logging in. If you do use password authentication then you will need to enter your password once for each of the two SSH connections.

## Automatically update your Dotbot config file when you add files in Git

You can use this tool (implemented as a Git pre-commit hook) to automatically update Dotbot's config file when adding files in Git: https://github.com/gwerbin/dotbot-autobot.

## Uninstall script

Currently, dotbot does not support uninstalling the symlinks. This script can be a good starting point for users who want this feature ([source](https://github.com/anishathalye/dotbot/issues/152#issuecomment-394129600))

```python
#!/usr/bin/env python

from __future__ import print_function

import yaml
import os

CONFIG="install.conf.yaml"

stream = open(CONFIG, "r")
conf = yaml.load(stream, yaml.FullLoader)

for section in conf:
    if 'link' in section:
        for target in section['link']:
            realpath = os.path.expanduser(target)
            if os.path.islink(realpath):
                print("Removing ", realpath)
                os.unlink(realpath)
```

Here's an equivalent script for PowerShell ([source](https://github.com/anishathalye/dotfiles_template/pull/19#issuecomment-729518540), [powershell-yaml](https://github.com/cloudbase/powershell-yaml) required)

```ps1
$CONFIG = "install.conf.yaml"

$confObj = ConvertFrom-Yaml ([string](Get-Content $CONFIG -Raw))
foreach ($target in ($confObj | Where-Object Keys -eq link).Values.Keys) {
    if ((Get-Item $target -Force -ErrorAction SilentlyContinue).LinkType -eq "SymbolicLink") {
        Write-Host "Removing $target" -ForegroundColor Red
        Remove-Item $target
    }
}
```