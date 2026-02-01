#!/bin/bash
# validate.sh
# plugin.json, skills, agents, commands, hooks.json 검증

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

errors=0
total_checked=0

# plugin.json 검증
echo "Plugin.json"
echo "--------------------------------"
plugin_file="$ROOT_DIR/.claude-plugin/plugin.json"
if [[ -f "$plugin_file" ]]; then
    total_checked=$((total_checked + 1))
    plugin_valid=true

    # JSON 문법 검증
    if command -v jq &> /dev/null; then
        if ! jq . "$plugin_file" > /dev/null 2>&1; then
            echo "[FAIL] plugin.json - Invalid JSON syntax"
            plugin_valid=false
            errors=$((errors + 1))
        fi
    else
        if ! ruby -rjson -e "JSON.parse(File.read('$plugin_file'))" 2>/dev/null; then
            echo "[FAIL] plugin.json - Invalid JSON syntax"
            plugin_valid=false
            errors=$((errors + 1))
        fi
    fi

    if [[ "$plugin_valid" == true ]]; then
        # 필수 필드 검증
        name=$(jq -r '.name // empty' "$plugin_file" 2>/dev/null)
        if [[ -z "$name" ]]; then
            echo "[FAIL] plugin.json - Missing required field: name"
            errors=$((errors + 1))
            plugin_valid=false
        fi

        # skills 필드 형식 검증 (string 또는 array)
        skills_type=$(jq -r 'if .skills then (.skills | type) else "missing" end' "$plugin_file" 2>/dev/null)
        if [[ "$skills_type" != "missing" && "$skills_type" != "array" && "$skills_type" != "string" ]]; then
            echo "[FAIL] plugin.json - skills must be string or array, got: $skills_type"
            errors=$((errors + 1))
            plugin_valid=false
        fi

        # agents 필드 형식 검증 (string 또는 array)
        agents_type=$(jq -r 'if .agents then (.agents | type) else "missing" end' "$plugin_file" 2>/dev/null)
        if [[ "$agents_type" != "missing" && "$agents_type" != "array" && "$agents_type" != "string" ]]; then
            echo "[FAIL] plugin.json - agents must be string or array, got: $agents_type"
            errors=$((errors + 1))
            plugin_valid=false
        fi

        # commands 필드 형식 검증 (string 또는 array)
        commands_type=$(jq -r 'if .commands then (.commands | type) else "missing" end' "$plugin_file" 2>/dev/null)
        if [[ "$commands_type" != "missing" && "$commands_type" != "array" && "$commands_type" != "string" ]]; then
            echo "[FAIL] plugin.json - commands must be string or array, got: $commands_type"
            errors=$((errors + 1))
            plugin_valid=false
        fi

        if [[ "$plugin_valid" == true ]]; then
            echo "[OK] plugin.json"
        fi
    fi
else
    echo "[FAIL] plugin.json not found"
    errors=$((errors + 1))
fi
echo ""

# YAML frontmatter 검증 함수
validate_yaml_frontmatter() {
    local file="$1"
    local name="$2"

    # frontmatter 추출 (첫 번째 --- 와 두 번째 --- 사이)
    frontmatter=$(awk '/^---$/{if(++c==2)exit}c==1' "$file")

    if [[ -z "$frontmatter" ]]; then
        echo "[FAIL] $name - No YAML frontmatter found"
        return 1
    fi

    # Ruby로 YAML 검증 (macOS 기본 설치)
    if echo "$frontmatter" | ruby -ryaml -e 'YAML.safe_load(STDIN.read)' 2>/dev/null; then
        echo "[OK] $name"
        return 0
    else
        echo "[FAIL] $name - YAML syntax error"
        echo "   File: $file"
        echo "   Tip: Check for unquoted colons in description"
        return 1
    fi
}

# Skills 검증
echo "Skills"
echo "--------------------------------"
skills_checked=0
for skill_dir in "$ROOT_DIR"/skills/*/; do
    if [[ -d "$skill_dir" ]]; then
        skill_name=$(basename "$skill_dir")
        skill_file="$skill_dir/SKILL.md"

        if [[ -f "$skill_file" ]]; then
            skills_checked=$((skills_checked + 1))
            if ! validate_yaml_frontmatter "$skill_file" "$skill_name"; then
                errors=$((errors + 1))
            fi
        else
            echo "[FAIL] $skill_name - SKILL.md not found"
            errors=$((errors + 1))
        fi
    fi
done
echo "Checked: $skills_checked"
total_checked=$((total_checked + skills_checked))
echo ""

# Agents 검증
echo "Agents"
echo "--------------------------------"
agents_checked=0
for agent_file in "$ROOT_DIR"/agents/*.md; do
    if [[ -f "$agent_file" ]]; then
        agents_checked=$((agents_checked + 1))
        agent_name=$(basename "$agent_file" .md)
        if ! validate_yaml_frontmatter "$agent_file" "$agent_name"; then
            errors=$((errors + 1))
        fi
    fi
done
echo "Checked: $agents_checked"
total_checked=$((total_checked + agents_checked))
echo ""

# Commands 검증
echo "Commands"
echo "--------------------------------"
commands_checked=0
for cmd_file in "$ROOT_DIR"/commands/*.md; do
    if [[ -f "$cmd_file" ]]; then
        commands_checked=$((commands_checked + 1))
        cmd_name=$(basename "$cmd_file" .md)
        if ! validate_yaml_frontmatter "$cmd_file" "$cmd_name"; then
            errors=$((errors + 1))
        fi
    fi
done
echo "Checked: $commands_checked"
total_checked=$((total_checked + commands_checked))
echo ""

# hooks.json 검증
echo "Hooks"
echo "--------------------------------"
hooks_file="$ROOT_DIR/hooks/hooks.json"
if [[ -f "$hooks_file" ]]; then
    total_checked=$((total_checked + 1))
    # jq 또는 ruby로 JSON 검증
    if command -v jq &> /dev/null; then
        if jq . "$hooks_file" > /dev/null 2>&1; then
            echo "[OK] hooks.json"
        else
            echo "[FAIL] hooks.json - Invalid JSON"
            errors=$((errors + 1))
        fi
    else
        # jq 없으면 ruby 사용
        if ruby -rjson -e "JSON.parse(File.read('$hooks_file'))" 2>/dev/null; then
            echo "[OK] hooks.json"
        else
            echo "[FAIL] hooks.json - Invalid JSON"
            errors=$((errors + 1))
        fi
    fi
    echo "Checked: 1"
else
    echo "[SKIP] hooks.json not found"
    echo "Checked: 0"
fi
echo ""

# 결과 출력
echo "================================"
echo "Total checked: $total_checked"

if [[ $errors -gt 0 ]]; then
    echo "Errors: $errors"
    exit 1
else
    echo "All valid!"
    exit 0
fi
