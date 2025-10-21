# Dotfiles
[![Test install script](https://github.com/jessiepuls/dotfiles/actions/workflows/install.yml/badge.svg)](https://github.com/jessiepuls/dotfiles/actions/workflows/install.yml)

Managed with [Chezmoi](https://github.com/twpayne/chezmoi)

## Prerequisites

1. Authenticate to the AppStore -- This is the only requirement that will break things if you don't. I'd like to add a check to see if you're authenticated, and prompt you to auth (or skip installing apps that require it if you don't), but mas removed the command that allows you to see who is authenticated. Here's an issue in their project to track: (https://github.com/mas-cli/mas/issues/417)

## Profiles

This repository supports multiple configuration profiles to customize package installation for different contexts:

### Available Profiles

- **personal** - Personal machine with entertainment and personal productivity apps
  - Adds: calibre, qflipper, steam, codex, ffmpeg

- **td** - Work/development machine with professional tooling
  - Includes all development tools: ansible, k9s, localstack, poetry, alfred, spotify, discord, gcloud-cli, todoist

- **client** - Client-specific machine configuration
  - Minimal additions for client work environments

### Setting Your Profile

The `PROFILE` environment variable determines which packages are installed. Set it before running chezmoi:

#### During initial setup

Set the profile when bootstrapping:

```bash
# Personal machine
PROFILE=personal sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply jessiepuls

# Work machine
PROFILE=td sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply jessiepuls

# Client machine
PROFILE=client sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply jessiepuls
```

#### For subsequent updates

Prefix chezmoi commands with the profile:

```bash
PROFILE=personal chezmoi apply
PROFILE=td chezmoi update
```

#### Making it persistent

To avoid typing `PROFILE=` each time, add it to a shell configuration file that chezmoi doesn't manage (like `~/.zshenv` or `~/.profile`):

```bash
echo 'export PROFILE=personal' >> ~/.zshenv
```

#### Verifying your profile

Check which profile is currently set:

```bash
echo $PROFILE
```

All profiles include a core set of essential tools (chezmoi, git, docker, vscode, 1password, etc.) defined in the base configuration.

## Setup

There are a couple of options for running the install. If you haven't already installed Chezmoi you can do an all in one install/bootstrap by running the following:

```bash
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply jessiepuls
```

If you've already bootstrapped, and just want to apply again you can run:

```bash
chezmoi upgrade # Upgrade chezmoi to the latest version
chezmoi apply # apply changes without pulling updates
chezmoi update # pull and apply changes
```

Want to just run a script to apply directly? Here you go:

```bash
chezmoi cd # change to the directory where config is saved. By default this is going to be ~/.local/share/chezmoi
./install.sh
```
