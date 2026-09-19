#!/usr/bin/env bash
# Copy portable skills into any harness directory; no default vendor target.
# Usage: install.sh (--dest PATH | --target claude|codex|both) [skill-name]
#                   [--dry-run] [--retire-superseded]
set -euo pipefail
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_root="$repo_root/skills"
target=""; destination=""; only_skill=""; dry_run=false; retire=false
while [ "$#" -gt 0 ]; do
    case "$1" in
        --dest|--target)
            [ "$#" -ge 2 ] && [ -n "$2" ] || { echo "Missing value for $1" >&2; exit 1; }
            if [ "$1" = --dest ]; then destination="$2"; else target="$2"; fi
            shift 2 ;;
        --dry-run) dry_run=true; shift ;;
        --retire-superseded) retire=true; shift ;;
        --*) echo "Unknown option: $1" >&2; exit 1 ;;
        *) [ -z "$only_skill" ] || { echo 'Only one skill name is supported' >&2; exit 1; }; only_skill="$1"; shift ;;
    esac
done
if { [ -z "$target" ] && [ -z "$destination" ]; } || { [ -n "$target" ] && [ -n "$destination" ]; }; then
    echo 'Specify either --dest <skills-directory> or --target claude|codex|both.' >&2; exit 1
fi
case "$target" in ''|claude|codex|both) ;; *) echo "Unknown target: $target" >&2; exit 1 ;; esac
if $retire && [ -n "$only_skill" ]; then echo 'Retiring old names requires a full installation.' >&2; exit 1; fi
[ -d "$source_root" ] || { echo "Missing source: $source_root" >&2; exit 1; }
if [ -n "$only_skill" ]; then
    [[ "$only_skill" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo 'Invalid skill name' >&2; exit 1; }
    [ -f "$source_root/$only_skill/SKILL.md" ] || { echo "Unknown skill: $only_skill" >&2; exit 1; }
fi

# Resolve nonexistent destinations without creating anything during a dry run.
normalize_path() {
    local input="$1" part result="" parts=()
    case "$input" in /*) ;; *) input="$PWD/$input" ;; esac
    IFS='/' read -r -a parts <<< "$input"
    for part in "${parts[@]}"; do
        case "$part" in ''|.) ;; ..) result="${result%/*}" ;; *) result="$result/$part" ;; esac
    done
    printf '%s\n' "${result:-/}"
}
assert_plain_path() {
    local cursor="$1"
    while [ "$cursor" != / ] && [ "$cursor" != . ]; do
        [ ! -L "$cursor" ] || { echo "Linked path is not supported: $cursor" >&2; exit 1; }
        cursor="$(dirname "$cursor")"
    done
}
copy_tree() {
    local from="$1" to="$2" entry name
    mkdir -p "$to"
    while IFS= read -r -d '' entry; do
        name="$(basename "$entry")"
        case "$name" in node_modules|__pycache__|.git|.coverage) continue ;; esac
        [ ! -L "$entry" ] || { echo "Linked source is not supported: $entry" >&2; exit 1; }
        if [ -d "$entry" ]; then copy_tree "$entry" "$to/$name"; else cp -p "$entry" "$to/$name"; fi
    done < <(find "$from" -mindepth 1 -maxdepth 1 -print0)
}
destinations=()
if [ -n "$destination" ]; then destinations+=("$destination"); fi
if [ "$target" = claude ] || [ "$target" = both ]; then destinations+=("$HOME/.claude/skills"); fi
if [ "$target" = codex ] || [ "$target" = both ]; then destinations+=("${CODEX_HOME:-$HOME/.codex}/skills"); fi
stamp="$(date +%Y%m%d-%H%M%S)-$$"
for destination in "${destinations[@]}"; do
    dest_root="$(normalize_path "$destination")"
    case "${dest_root%/}/" in "$source_root/"*) echo 'Destination overlaps source skills.' >&2; exit 1 ;; esac
    case "$source_root/" in "${dest_root%/}/"*) echo 'Destination overlaps source skills.' >&2; exit 1 ;; esac
    assert_plain_path "$dest_root"
    backup_root="$(dirname "$dest_root")/skill-backups/$stamp"
    assert_plain_path "$backup_root"
    for dir in "$source_root"/*/; do
        [ -f "$dir/SKILL.md" ] || continue
        name="$(basename "$dir")"
        [ -z "$only_skill" ] || [ "$name" = "$only_skill" ] || continue
        dest="$dest_root/$name"
        assert_plain_path "$dest"
        assert_plain_path "${dir%/}"
        if [ -n "$(find "$dir" -type l -print -quit)" ]; then echo "Linked source: $dir" >&2; exit 1; fi
        if $dry_run; then echo "Would install $name -> $dest"; continue; fi
        if [ -e "$dest" ]; then mkdir -p "$backup_root"; mv "$dest" "$backup_root/$name"; fi
        copy_tree "${dir%/}" "$dest"
        echo "Installed $name -> $dest"
    done
    if $retire; then
        while IFS= read -r name || [ -n "$name" ]; do
            name="${name%$'\r'}"
            case "$name" in ''|'#'*) continue ;; esac
            [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "Invalid retired name: $name" >&2; exit 1; }
            [ ! -e "$source_root/$name" ] || { echo "Cannot retire current skill: $name" >&2; exit 1; }
            old="$dest_root/$name"
            assert_plain_path "$old"
            [ -e "$old" ] || continue
            if $dry_run; then echo "Would retire $name -> $backup_root"; continue; fi
            mkdir -p "$backup_root"
            mv "$old" "$backup_root/$name"
            echo "Retired $name -> $backup_root/$name"
        done < "$repo_root/scripts/retired-skills.txt"
    fi
done
if $dry_run; then echo 'Preview complete; no files changed.'; else echo 'Installation complete.'; fi
