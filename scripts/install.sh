#!/usr/bin/env bash
# Installs every skill under .claude/skills into the user's global Claude Code
# skills directory (~/.claude/skills), making them available in every project,
# not just this repo.
#
# Usage:
#   ./scripts/install.sh                 # install/update all skills
#   ./scripts/install.sh notion-skill    # install/update just one
#   ./scripts/install.sh --dry-run       # preview without copying

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_root="$repo_root/.claude/skills"
dest_root="$HOME/.claude/skills"

dry_run=false
only_skill=""
for arg in "$@"; do
    case "$arg" in
        --dry-run) dry_run=true ;;
        *) only_skill="$arg" ;;
    esac
done

if [ ! -d "$source_root" ]; then
    echo "No skills found at $source_root" >&2
    exit 1
fi

mkdir -p "$dest_root"

for dir in "$source_root"/*/; do
    name="$(basename "$dir")"

    if [ -n "$only_skill" ] && [ "$name" != "$only_skill" ]; then
        continue
    fi

    dest="$dest_root/$name"
    if [ -d "$dest" ]; then
        verb="Updated"
    else
        verb="Installed"
    fi

    if [ "$dry_run" = true ]; then
        echo "would ${verb,,} $name -> $dest"
        continue
    fi

    rm -rf "$dest"
    cp -r "$dir" "$dest"
    echo "$verb $name -> $dest"
done

echo ""
echo "Done. Skills are installed globally and available in any Claude Code project."
