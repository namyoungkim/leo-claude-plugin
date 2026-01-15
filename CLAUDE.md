# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal Claude Skills repository for use with Claude Code, Claude.ai, and API. Skills are reusable instruction sets that trigger based on user requests.

## Repository Structure

```
leo-claude-skills/
├── <skill-name>/
│   ├── SKILL.md           # Required - skill definition with YAML frontmatter
│   ├── scripts/           # Optional - executable code
│   ├── references/        # Optional - additional context files
│   └── assets/            # Optional - templates, config files
└── scripts/
    ├── sync-to-claude-code.sh
    ├── skill-manager.sh
    └── validate-skills.sh
```

## Skill Definition Format

Each skill folder must contain a `SKILL.md` with YAML frontmatter:

```yaml
---
name: skill-name          # 64 chars max
description: ...          # 200 chars max, include trigger conditions
---
```

## Available Skills

- **python-project**: Python project setup with uv + ruff + ty + pytest (Astral Toolchain)
- **coding-problem-solver**: Structured coding interview problem solving for Staff-level preparation
- **git-master**: Atomic commits, rebase/squash, history search (blame, bisect)
- **git-workflow**: GitHub Flow branching strategy, commit message conventions, PR workflows
- **git-worktree**: Git worktree for parallel Claude development, multiple instances
- **opensearch-client**: OpenSearch Python client library for hybrid search with Korean support
- **opensearch-server**: Docker-based OpenSearch server setup and management
- **product-planning**: 인터뷰 기반 제품/프로젝트 기획 (Impact Mapping, User Story Mapping, C4 Model, ADR)

## Scripts

```bash
# Sync skills to Claude Code
./scripts/sync-to-claude-code.sh

# Manage skills (list/enable/disable)
./scripts/skill-manager.sh list
./scripts/skill-manager.sh disable <skill-name>
./scripts/skill-manager.sh enable <skill-name>

# Validate YAML frontmatter
./scripts/validate-skills.sh
```

- `sync-to-claude-code.sh`: Creates symlinks from this repo to `~/.claude/skills/`
- `skill-manager.sh`: Moves skills between `~/.claude/skills/` and `~/.claude/skills-disabled/`
- `validate-skills.sh`: Validates YAML frontmatter in all SKILL.md files

## Adding a New Skill

1. Create folder: `mkdir new-skill`
2. Create `new-skill/SKILL.md` with required YAML frontmatter
3. Keep SKILL.md under 500 lines; use `references/` for additional content
4. Run sync script
