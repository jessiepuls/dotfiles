# Dotfiles
[![Test install script](https://github.com/jessiepuls/dotfiles/actions/workflows/install.yml/badge.svg)](https://github.com/jessiepuls/dotfiles/actions/workflows/install.yml)

Managed with [Chezmoi](https://github.com/twpayne/chezmoi)

## Prerequisites

1. Authenticate to the AppStore -- This is the only requirement that will break things if you don't. I'd like to add a check to see if you're authenticated, and prompt you to auth (or skip installing apps that require it if you don't), but mas removed the command that allows you to see who is authenticated. Here's an issue in their project to track: (https://github.com/mas-cli/mas/issues/417)

## Setup

There are a couple of options for running the install. If you haven't already installed Chezmoi you can do an all in one install/bootstrap by running the following:

```bash
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply <github-username>
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
