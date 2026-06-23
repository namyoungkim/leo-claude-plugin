#!/usr/bin/env bash
# Sync this Claude Code plugin's skills and agents into Codex's home directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
STATE_DIR="$CODEX_HOME/.leo-claude-plugin"
SKILLS_MANIFEST="$STATE_DIR/skills.manifest"
AGENTS_MANIFEST="$STATE_DIR/agents.manifest"
DRY_RUN=false

usage() {
    cat <<'USAGE'
Usage: sync-to-codex.sh [--dry-run]

Environment:
  CODEX_HOME   Codex home directory. Defaults to ~/.codex.
USAGE
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if ! command -v rsync >/dev/null 2>&1; then
    echo "rsync is required" >&2
    exit 1
fi

contains_line() {
    local needle="$1"
    local haystack="$2"

    [[ "$haystack" == *$'\n'"$needle"$'\n'* ]]
}

prune_stale_entries() {
    local manifest="$1"
    local current_names="$2"
    local target_dir="$3"
    local stale_path
    local name

    [[ -f "$manifest" ]] || return 0

    while IFS= read -r name; do
        [[ -n "$name" ]] || continue
        if ! contains_line "$name" "$current_names"; then
            stale_path="$target_dir/$name"
            if [[ "$DRY_RUN" == true ]]; then
                echo "Would remove stale $stale_path"
            else
                rm -rf "$stale_path"
            fi
        fi
    done < "$manifest"
}

rsync_flags=(-a --delete)
if [[ "$DRY_RUN" == true ]]; then
    rsync_flags+=(-n -v)
fi

if [[ "$DRY_RUN" == true ]]; then
    [[ -d "$CODEX_HOME/skills" ]] || echo "Would create $CODEX_HOME/skills"
    [[ -d "$CODEX_HOME/agents" ]] || echo "Would create $CODEX_HOME/agents"
    [[ -d "$STATE_DIR" ]] || echo "Would create $STATE_DIR"
else
    mkdir -p "$CODEX_HOME/skills" "$CODEX_HOME/agents" "$STATE_DIR"
fi

current_skills=$'\n'
skills_synced=0
for skill_dir in "$ROOT_DIR"/skills/*; do
    [[ -d "$skill_dir" ]] || continue
    skill_name="$(basename "$skill_dir")"
    current_skills+="$skill_name"$'\n'
    if [[ "$DRY_RUN" == true && ! -d "$CODEX_HOME/skills" ]]; then
        echo "Would sync $skill_dir/ -> $CODEX_HOME/skills/$skill_name/"
    else
        rsync "${rsync_flags[@]}" "$skill_dir/" "$CODEX_HOME/skills/$skill_name/"
    fi
    skills_synced=$((skills_synced + 1))
done

current_agents=$'\n'
agents_synced=0
for agent_file in "$ROOT_DIR"/agents/*.md; do
    [[ -f "$agent_file" ]] || continue
    agent_name="$(basename "$agent_file")"
    current_agents+="$agent_name"$'\n'
    if [[ "$DRY_RUN" == true && ! -d "$CODEX_HOME/agents" ]]; then
        echo "Would sync $agent_file -> $CODEX_HOME/agents/"
    else
        rsync "${rsync_flags[@]}" "$agent_file" "$CODEX_HOME/agents/"
    fi
    agents_synced=$((agents_synced + 1))
done

prune_stale_entries "$SKILLS_MANIFEST" "$current_skills" "$CODEX_HOME/skills"
prune_stale_entries "$AGENTS_MANIFEST" "$current_agents" "$CODEX_HOME/agents"

if [[ "$DRY_RUN" == true ]]; then
    echo "Would update $SKILLS_MANIFEST"
    echo "Would update $AGENTS_MANIFEST"
    echo "Dry run complete: $skills_synced skills, $agents_synced agents checked."
else
    printf "%s" "${current_skills#$'\n'}" > "$SKILLS_MANIFEST"
    printf "%s" "${current_agents#$'\n'}" > "$AGENTS_MANIFEST"
    echo "Synced $skills_synced skills and $agents_synced agents to $CODEX_HOME."
fi
