#!/bin/bash
set -euo pipefail

# Determinate Nix is a manual prerequisite.
if ! command -v nix >/dev/null 2>&1; then
    echo "nix command not found, skipping devenv and direnv install" >&2
    exit 0
fi

# Check the profile rather than PATH so each package uses its pinned revision.
profile=$(nix profile list --json)
if ! printf '%s\n' "$profile" | grep -Fq '54091ad9447f642c85529caaabfdc3eb9cefa5d0'; then
    nix profile add nixpkgs/54091ad9447f642c85529caaabfdc3eb9cefa5d0#devenv
fi
if ! printf '%s\n' "$profile" | grep -Fq 'd1373fa92b2329411ec53718e2d722e7471f2f88'; then
    nix profile add nixpkgs/d1373fa92b2329411ec53718e2d722e7471f2f88#direnv
fi
