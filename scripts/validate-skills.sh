#!/bin/bash
# validate-skills.sh
# SKILL.md 파일들의 YAML frontmatter 검증

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$(dirname "$SCRIPT_DIR")/skills"

echo "Validating SKILL.md files"
echo "================================"

errors=0
checked=0

for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_file="$skill_dir/SKILL.md"

    # SKILL.md가 있는 폴더만 처리
    if [[ -f "$skill_file" ]]; then
        checked=$((checked + 1))

        # frontmatter 추출 (첫 번째 --- 와 두 번째 --- 사이)
        frontmatter=$(awk '/^---$/{if(++c==2)exit}c==1' "$skill_file")

        # Ruby로 YAML 검증 (macOS 기본 설치)
        if echo "$frontmatter" | ruby -ryaml -e 'YAML.safe_load(STDIN.read)' 2>/dev/null; then
            echo "[OK] $skill_name"
        else
            echo "[FAIL] $skill_name - YAML syntax error"
            echo "   File: $skill_file"
            echo "   Tip: Check for unquoted colons in description"
            errors=$((errors + 1))
        fi
    fi
done

echo ""
echo "================================"
echo "Checked: $checked skills"

if [[ $errors -gt 0 ]]; then
    echo "Errors: $errors"
    exit 1
else
    echo "All valid!"
    exit 0
fi
