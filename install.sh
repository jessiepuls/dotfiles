#!/bin/bash

set -eufo pipefail

echo ""
echo "🤚  This script will setup .dotfiles for you."
read -n 1 -r -s -p $'    Press any key to continue or Ctrl+C to abort...\n\n'

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  if [ "$(command -v curl)" ]; then
    sh -c "$(curl -fsLS https://git.io/chezmoi)" -- -b "$bin_dir"
  elif [ "$(command -v wget)" ]; then
    sh -c "$(wget -qO- https://git.io/chezmoi)" -- -b "$bin_dir"
  else
    echo "To install chezmoi, you must have curl or wget installed." >&2
    exit 1
  fi
else
  chezmoi=chezmoi
fi

echo "pwd=$(pwd)"

echo "chezmoi=$chezmoi"

# If profile env var isn't set, ask user
if [ -z "${PROFILE:-}" ]; then
  echo ""
  echo "→ Please choose a profile to use:"
  echo ""
  select profile in "client" "td" "personal" "none"; do
    case $profile in
      client ) export PROFILE="client"; export PROFILE_WAS_SET_BY_SCRIPT="true"; break;;
      td ) export PROFILE="td"; export PROFILE_WAS_SET_BY_SCRIPT="true"; break;;
      personal ) export PROFILE="personal"; export PROFILE_WAS_SET_BY_SCRIPT="true"; break;;
      none ) export PROFILE=""; break;;
      * ) echo "Invalid selection. Please try again.";;
    esac
  done
fi

echo "💡 Using profile: '${PROFILE:-none}'"

# If a profile was selected during this run, ask if it should be added to ~/.zshenv
# Only prompt if PROFILE was just set (not already in environment before script ran)
if [ -n "${PROFILE:-}" ] && [ "${PROFILE_WAS_SET_BY_SCRIPT:-}" = "true" ]; then
  zshenv_file="$HOME/.zshenv"

  # Check if PROFILE is already set in ~/.zshenv
  profile_already_set=false
  if [ -f "$zshenv_file" ] && grep -q "^export PROFILE=" "$zshenv_file"; then
    # Check if the value matches
    current_zshenv_profile=$(grep "^export PROFILE=" "$zshenv_file" | sed 's/export PROFILE="\(.*\)"/\1/' | sed "s/export PROFILE='\(.*\)'/\1/" | sed 's/export PROFILE=\(.*\)/\1/')
    if [ "$current_zshenv_profile" = "$PROFILE" ]; then
      profile_already_set=true
      echo "💡 PROFILE=${PROFILE} is already set in ~/.zshenv"
    fi
  fi

  if [ "$profile_already_set" = "false" ]; then
    echo ""
    echo "→ Would you like to add PROFILE=${PROFILE} to ~/.zshenv?"
    echo "  (This will ensure the profile is set for all shell sessions)"
    echo ""
    read -n 1 -r -p "Add to ~/.zshenv? [y/N] " response
    echo ""

    if [[ "$response" =~ ^[Yy]$ ]]; then
      profile_line="export PROFILE=\"${PROFILE}\""

      # Check if the profile line already exists in ~/.zshenv
      if [ -f "$zshenv_file" ] && grep -q "^export PROFILE=" "$zshenv_file"; then
        # Update existing PROFILE line
        if [ "$(uname)" = "Darwin" ]; then
          sed -i '' "s/^export PROFILE=.*/export PROFILE=\"${PROFILE}\"/" "$zshenv_file"
        else
          sed -i "s/^export PROFILE=.*/export PROFILE=\"${PROFILE}\"/" "$zshenv_file"
        fi
        echo "✅ Updated PROFILE in $zshenv_file"
      else
        # Append new PROFILE line
        echo "$profile_line" >> "$zshenv_file"
        echo "✅ Added PROFILE to $zshenv_file"
      fi
    else
      echo "⏭️  Skipping ~/.zshenv update"
    fi
  fi
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
echo "script_dir=$script_dir"

# exec: replace current process with chezmoi init
exec "$chezmoi" init --apply "--source=$script_dir"
