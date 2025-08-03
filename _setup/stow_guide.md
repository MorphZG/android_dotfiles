# Using `stow` to Manage Your Dotfiles

GNU `stow` is a symlink farm manager which takes distinct packages of software and installs them in a single directory tree. We can use it to manage our configuration files (dotfiles) by treating each configuration (like `zsh`, `nvim`, etc.) as a package.

This guide will walk you through using `stow` with your existing `.dotfiles` repository.

## Core Concepts

1.  **Stow Directory:** This is the directory where your dotfiles repository lives. In your case, it's `~/.dotfiles`.
2.  **Packages:** Each subdirectory inside your stow directory that contains a set of configuration files is a "package." For you, these are `zsh`, `nvim`, `gitconfig`, `tmux`, etc.
3.  **Target Directory:** This is the directory where the symlinks will be created. By default, `stow` uses the parent directory of the stow directory. Since your stow directory is `~/.dotfiles`, the target is `~` (your home directory), which is exactly what we want.
4.  **The Action:** When you run `stow <package>`, `stow` looks inside the `<package>` directory (e.g., `~/.dotfiles/zsh`) and creates symlinks for its contents in the target directory (`~`), recreating the directory structure as needed. For example, `~/.dotfiles/zsh/.zshrc` will be symlinked to `~/.zshrc`.

## Step-by-Step Guide

### 1. Install `stow`

First, ensure `stow` is installed in Termux.

```bash
pkg install stow
```

### 2. Handling Existing Files (The Conflict)

Before you can create symlinks, you must deal with any configuration files that already exist in your home directory. If you try to `stow` a package when the target files already exist, `stow` will show a conflict error to prevent you from accidentally overwriting your files.

The safest way to resolve this is to back up your existing files before running `stow`.

### 3. The "Backup and Stow" Workflow

Let's walk through the process for your `zsh` configuration.

#### A. Back Up Existing Files

Move your current `.zshrc` file and `.oh-my-zsh` directory to a backup location.

```bash
# Back up the file
mv ~/.zshrc ~/.zshrc.bak

# Back up the directory
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
```

#### B. Stow the Package

Navigate to your `.dotfiles` directory and use the `stow` command.

```bash
cd ~/.dotfiles
stow zsh
```

This command tells `stow` to create symlinks for everything inside the `zsh` package directory.

### 4. Verify the Symlinks

You can check that the symlinks were created correctly by listing the files in your home directory.

```bash
ls -la ~
```

You should see output similar to this, where the `->` indicates a symlink:

```
lrwxrwxrwx. 1 user user   24 Aug  2 18:42 .oh-my-zsh -> .dotfiles/zsh/.oh-my-zsh
lrwxrwxrwx. 1 user user   20 Aug  2 18:42 .zshrc -> .dotfiles/zsh/.zshrc
```

## General Workflow Summary

You can apply this "Backup and Stow" process to all your other dotfiles. For any given package (e.g., `gitconfig`):

1.  **Backup:** `mv ~/.gitconfig ~/.gitconfig.bak`
2.  **Stow:** `stow gitconfig`

### Stowing Multiple Packages

You can also `stow` multiple packages at the same time.

```bash
# Make sure you have backed up the configs for all of them first!
stow zsh nvim gitconfig tmux
```

### Removing (Unstowing) Packages

If you want to remove the symlinks created by `stow` for a specific package, use the `-D` (delete) flag.

```bash
# From within your .dotfiles directory
stow -D zsh
```

This will safely remove the symlinks, allowing you to restore your backup files or manage them differently.
