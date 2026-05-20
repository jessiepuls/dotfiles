# Dotfiles
[![Test install script](https://github.com/jessiepuls/dotfiles/actions/workflows/install.yml/badge.svg)](https://github.com/jessiepuls/dotfiles/actions/workflows/install.yml)

Managed with [Chezmoi](https://github.com/twpayne/chezmoi)

## Prerequisites

1. Authenticate to the AppStore -- This is the only requirement that will break things if you don't. I'd like to add a check to see if you're authenticated, and prompt you to auth (or skip installing apps that require it if you don't), but mas removed the command that allows you to see who is authenticated. Here's an issue in their project to track: (https://github.com/mas-cli/mas/issues/417)

## Setup

Fresh machine (installs chezmoi, clones this repo, applies):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jessiepuls
```

Already bootstrapped:

```bash
chezmoi upgrade # Upgrade chezmoi to the latest version
chezmoi apply   # apply changes without pulling updates
chezmoi update  # pull and apply changes
```

## Profiles

This repository supports configuration profiles that customize package installation:

- **personal** — Personal machine with entertainment and personal productivity apps (calibre, qflipper, steam, codex, ffmpeg)
- **td** — Work/development machine with professional tooling (ansible, k9s, localstack, poetry, alfred, spotify, discord, gcloud-cli, todoist)
- **client** — Reserved for client-specific machine configuration
- **none** — Base packages only

All profiles include the core set of tools (chezmoi, git, docker, vscode, 1password, etc.).

On first `chezmoi init`, chezmoi prompts you to pick a profile and stores the choice in `~/.config/chezmoi/chezmoi.toml`. Subsequent runs reuse that choice without re-prompting.

To change the profile later, edit `~/.config/chezmoi/chezmoi.toml` directly or re-run `chezmoi init` after deleting the `profile` line.
