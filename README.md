# Dotfiles
[![Test bootstrap](https://github.com/jessiepuls/dotfiles/actions/workflows/bootstrap.yml/badge.svg)](https://github.com/jessiepuls/dotfiles/actions/workflows/bootstrap.yml)

Managed with [Chezmoi](https://github.com/twpayne/chezmoi)

## Prerequisites

1. Authenticate to the AppStore -- This is the only requirement that will break things if you don't. I'd like to add a check to see if you're authenticated, and prompt you to auth (or skip installing apps that require it if you don't), but mas removed the command that allows you to see who is authenticated. Here's an issue in their project to track: (https://github.com/mas-cli/mas/issues/417)

## Setup

Fresh machine (installs chezmoi, clones this repo, applies):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$(mktemp -d)" init --apply jessiepuls
```

`-b "$(mktemp -d)"` installs the bootstrap chezmoi into a throwaway dir so it runs
once and is discarded. Homebrew installs the persistent copy during `chezmoi apply`
and owns updates from then on — this avoids a stale standalone binary shadowing the
Homebrew one on `PATH`.

Already bootstrapped:

```bash
brew upgrade chezmoi # Upgrade chezmoi (Homebrew owns it)
chezmoi apply        # apply changes without pulling updates
chezmoi update       # pull and apply changes
```

## Profiles

This repository supports configuration profiles that customize package installation:

- **personal** — Personal-only additions on top of the shared set (ffmpeg, calibre, qflipper, steam)
- **td** — No td-only packages; shares the `personal | td` set below
- **client** — Reserved for client-specific machine configuration (currently empty)
- **none** — Base packages only

Packages shared by **personal** and **td**: pi-coding-agent, mas, Claude desktop, Paprika, pipx, alfred, discord, gcloud-cli, spotify, todoist.

All profiles include the core set of tools (chezmoi, git, gh, neovim, mise, docker-desktop, vscode, cursor, claude-code, codex, cmux, 1password, etc. — see `dot_Brewfile.tmpl` for the full list).

On first `chezmoi init`, chezmoi prompts you to pick a profile and stores the choice in `~/.config/chezmoi/chezmoi.toml`. Subsequent runs reuse that choice without re-prompting.

To change the profile later, edit `~/.config/chezmoi/chezmoi.toml` directly or re-run `chezmoi init` after deleting the `profile` line.

## Managed configs

In addition to top-level dotfiles (`~/.zshrc`, `~/.gitconfig`, etc.), this repo manages:

- `~/.config/cmux/cmux.json` — cmux workspace layout and commands
- `~/.config/nvim/` — Neovim configuration
- `~/.Brewfile` — Homebrew bundle (templated by profile and OS)
- `~/.tool-versions` — mise-managed tool versions (terraform, opentofu, terragrunt, terraform-docs)

Edits to these live files will be overwritten on the next `chezmoi apply`. Edit the source files in this repo instead (or use `chezmoi edit <path>`).
