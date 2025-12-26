#!/bin/bash
# skill-manager.sh
# Claude Code 스킬 활성화/비활성화 관리

set -e

SKILLS_REPO="$HOME/leo-claude-skills"
CLAUDE_SKILLS="$HOME/.claude/skills"
DISABLED_DIR="$HOME/.claude/skills-disabled"

mkdir -p "$CLAUDE_SKILLS" "$DISABLED_DIR"

case "$1" in
    list)
        echo "📦 Active skills:"
        ls -1 "$CLAUDE_SKILLS" 2>/dev/null || echo "  (none)"
        echo ""
        echo "💤 Disabled skills:"
        ls -1 "$DISABLED_DIR" 2>/dev/null || echo "  (none)"
        ;;
    enable)
        if [[ -z "$2" ]]; then
            echo "Usage: $0 enable <skill-name>"
            exit 1
        fi
        if [[ -L "$DISABLED_DIR/$2" ]] || [[ -d "$DISABLED_DIR/$2" ]]; then
            mv "$DISABLED_DIR/$2" "$CLAUDE_SKILLS/"
            echo "✅ Enabled: $2"
        else
            echo "❌ Skill not found in disabled: $2"
            exit 1
        fi
        ;;
    disable)
        if [[ -z "$2" ]]; then
            echo "Usage: $0 disable <skill-name>"
            exit 1
        fi
        if [[ -L "$CLAUDE_SKILLS/$2" ]] || [[ -d "$CLAUDE_SKILLS/$2" ]]; then
            mv "$CLAUDE_SKILLS/$2" "$DISABLED_DIR/"
            echo "💤 Disabled: $2"
        else
            echo "❌ Skill not found: $2"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {list|enable|disable} [skill-name]"
        echo ""
        echo "Commands:"
        echo "  list                  모든 스킬 상태 보기"
        echo "  enable <skill-name>   스킬 활성화"
        echo "  disable <skill-name>  스킬 비활성화"
        echo ""
        echo "Examples:"
        echo "  $0 list"
        echo "  $0 disable coding-problem-solver"
        echo "  $0 enable coding-problem-solver"
        ;;
esac
