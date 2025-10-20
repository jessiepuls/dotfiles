# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with [Chezmoi](https://www.chezmoi.io/). It contains configuration files, shell scripts, and automation for setting up development environments across macOS and Linux systems. The repository supports multiple profiles (personal, td, client) and handles OS-specific configurations through Chezmoi's templating system.

## Key Commands

### Applying Changes
```bash
# Apply all dotfiles to the system
chezmoi apply

# Pull updates from git and apply
chezmoi update

# Preview changes without applying
chezmoi diff

# Edit a file in chezmoi's source directory
chezmoi edit ~/.zshrc

# Change to chezmoi source directory
chezmoi cd
```

### Testing
```bash
# Run the install script directly (from chezmoi source directory)
./install.sh

# The CI/CD workflow tests installation on macOS
# See .github/workflows/install.yml
```

## Architecture

### Chezmoi Templating System

Files use Chezmoi's Go template syntax with the following key variables:

- `.chezmoi.os` - Operating system (darwin, linux)
- `.chezmoi.osRelease.id` - OS distribution ID
- `.profile` - Profile type (personal, td, client) set via `PROFILE` env var
- `.ci` - Boolean indicating CI environment

Template files use naming conventions:
- `dot_filename.tmpl` → `~/.filename` (templated)
- `dot_filename` → `~/.filename` (literal)
- Files in `.chezmoiscripts/` are run-once scripts with execution order determined by prefix numbers

### Installation Flow

The installation process follows this sequence (see `.chezmoiscripts/`):

1. **run_10_install-homebrew-packages.sh.tmpl** - Installs Homebrew and runs `brew bundle` using `~/.Brewfile` (conditionally installs packages based on profile and OS)
2. **run_20_install-apt-packages.sh.tmpl** - Installs apt packages on Linux systems
3. **run_30_install-mise-packages.sh.tmpl** - Installs packages via mise (asdf successor)
4. **run_40_install-gem-packages.sh.tmpl** - Installs Ruby gems
5. **run_50_git-setup.sh.tmpl** - Generates SSH keys for GitHub/GitLab, configures gh CLI, and authenticates
6. **run_60_shell_setup.sh.tmpl** - Sets up shell environment
7. **run_70_dock-settings.sh.tmpl** - Configures macOS Dock settings

Scripts check for `CI` environment variable and skip interactive steps in CI.

### Profile-Based Configuration

The Brewfile (`dot_Brewfile.tmpl`) uses conditional blocks:

- **Base packages** - Installed on all machines (chezmoi, gh, git, docker, vscode, etc.)
- **personal** profile - Adds personal software (calibre, steam, codex, ffmpeg)
- **personal OR td** profiles - Adds development tools (ansible, k9s, localstack, poetry, alfred, spotify)
- **client** profile - Reserved for client-specific packages
- **CI exclusions** - Skips awscli and golang on macOS CI (pre-installed)

### Shell Configuration

Shell setup is split across multiple files:

- `dot_zprofile.tmpl` - Environment variables, PATH setup, XDG directories, Homebrew initialization
- `dot_zshrc.tmpl` - Oh-My-Zsh configuration, mise integration, command-not-found handler
- `dot_zaliases.tmpl` - Custom aliases (python/pip, k8s shortcuts)

### Tool Versions

`dot_tool-versions.tmpl` defines versions for mise-managed tools:
- terragrunt 0.44.5
- terraform 1.11.3
- opentofu 1.9.0
- terraform-docs (latest)
- ruby 3.4

## Important Constraints

### Prerequisites
- **macOS users must authenticate to the App Store** before running install - `mas` CLI requires authentication and cannot check auth status (tracked in https://github.com/mas-cli/mas/issues/417)

### Conditional Installation
When modifying package installations:
- Check profile conditions in `dot_Brewfile.tmpl`
- Verify OS-specific conditions (`eq .chezmoi.os "darwin"`)
- Account for CI environment (`not .ci`) to avoid conflicts with pre-installed packages

### Git Setup Script
The `run_50_git-setup.sh.tmpl` script:
- Generates separate SSH keys for GitHub and GitLab at `~/.ssh/id_rsa_github` and `~/.ssh/id_rsa_gitlab`
- Skips execution in CI (checks `$CI` env var)
- Uses interactive web authentication for GitHub (`gh auth login --web`)
- Prompts for key name unless `$GITHUB_KEY_NAME` is set

## Configuration File Locations

- Homebrew bundle file: `$HOME/.Brewfile` (set via `HOMEBREW_BUNDLE_FILE`)
- VS Code settings: `Library/Application Support/Code/User/settings.json`
- SSH config: `dot_ssh/` directory
- Git configs: `dot_gitconfig`, `dot_gitconfig-td` (work profile)

## Common Patterns

### Adding New Packages
1. Add to `dot_Brewfile.tmpl` under appropriate profile section
2. Use conditional templating for profile/OS-specific packages
3. Test with `chezmoi apply` or `brew bundle install`

### Modifying Shell Configuration
1. Edit source files via `chezmoi edit ~/.zshrc` (or edit directly in source directory)
2. Use `.tmpl` extension for files needing templating
3. Apply changes with `chezmoi apply`

### Adding Run-Once Scripts
1. Create `.chezmoiscripts/run_XX_description.sh.tmpl` (XX determines execution order)
2. Add CI check if script should skip in CI: `if [[ -n $CI ]]; then exit 0; fi`
3. Make script idempotent (safe to run multiple times)
