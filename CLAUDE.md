# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal Claude Skills repository for use with Claude Code, Claude.ai, and API. Skills are reusable instruction sets that trigger based on user requests.

## Repository Structure

```
leo-claude-skills/
├── <skill-name>/
│   ├── SKILL.md           # Required - skill definition with YAML frontmatter
│   └── references/        # Optional - additional context files
└── scripts/
    └── sync-to-claude-code.sh
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

## Sync to Claude Code

```bash
./scripts/sync-to-claude-code.sh
```

Creates symlinks from this repo to `~/.claude/skills/` for each skill folder containing SKILL.md.

## Adding a New Skill

1. Create folder: `mkdir new-skill`
2. Create `new-skill/SKILL.md` with required YAML frontmatter
3. Keep SKILL.md under 500 lines; use `references/` for additional content
4. Run sync script
