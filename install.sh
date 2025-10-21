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
      client ) export PROFILE="client"; break;;
      td ) export PROFILE="td"; break;;
      personal ) export PROFILE="personal"; break;;
      none ) export PROFILE=""; break;;
      * ) echo "Invalid selection. Please try again.";;
    esac
  done
fi

echo "💡 Using profile: '${PROFILE:-none}'"

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
echo "script_dir=$script_dir"

# exec: replace current process with chezmoi init
exec "$chezmoi" init --apply "--source=$script_dir"
