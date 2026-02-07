---
name: git-worktree
description: "Git worktree 병렬 개발 가이드. 여러 Claude 인스턴스를 동시에 실행하거나, 브랜치 전환 없이 병렬 작업할 때 사용. 트리거: worktree, 워크트리, parallel Claude, 병렬 개발, 여러 인스턴스, 브랜치 전환 없이"
---

# Git Worktree for Parallel Development

## Overview

Git worktree allows multiple working directories from a single repository. Primary use: **run multiple Claude instances in parallel** on different features.

## Basic Commands

| Command | Description | Example |
|---------|-------------|---------|
| `git worktree add` | Create worktree | `git worktree add ../wt-1 -b feature/auth` |
| `git worktree list` | List worktrees | `git worktree list` |
| `git worktree remove` | Remove worktree | `git worktree remove ../wt-1` |
| `git worktree prune` | Cleanup deleted | `git worktree prune` |

## Parallel Claude Workflow

### Setup Worktrees

```bash
# From main repository
# Create worktree 1 for Claude A
git worktree add ../project-1 -b feature/auth

# Create worktree 2 for Claude B
git worktree add ../project-2 -b feature/dashboard
```

### Install Dependencies (each worktree)

```bash
# Python projects
cd ../project-1 && uv sync

# Node.js projects
cd ../project-1 && npm install

# Monorepo example
cd ../project-1 && uv sync && cd frontend && npm install
```

### Run Claude Instances

```bash
# Terminal 1
cd ../project-1 && claude

# Terminal 2
cd ../project-2 && claude
```

### Cleanup After Merge

```bash
# From main repo
git worktree remove ../project-1
git worktree remove ../project-2
```

## Recommended Directory Structure

```
~/project/
├── my-project/           # main (primary worktree)
├── my-project-1/         # Claude A workspace
├── my-project-2/         # Claude B workspace
└── my-project-hotfix/    # Urgent fixes
```

## Other Use Cases

### Urgent Hotfix
```bash
# Keep current work, create hotfix worktree
git worktree add ../project-hotfix main
cd ../project-hotfix
git checkout -b fix/critical-bug
# ... fix and commit ...
git push
git worktree remove ../project-hotfix
```

### PR Review
```bash
git worktree add ../review origin/feature/new-feature
cd ../review
# review code, run tests
git worktree remove ../review
```

### Build Test
```bash
git worktree add ../build-test main
cd ../build-test && npm run build
git worktree remove ../build-test
```

## Benefits

- No branch switching needed
- Each Claude has isolated workspace
- No file conflicts/overwrites
- No stashing required
- True parallel development

## Cautions

| Issue | Solution |
|-------|----------|
| Same branch in 2 worktrees | Not allowed - use different branches |
| Uncommitted changes | Commit or stash before removing worktree |
| `.git` is a file | Normal - worktrees use `.git` file, not folder |
| Dependencies | Run `uv sync`, `npm install` in each worktree |
| Disk space | Each worktree needs separate node_modules |

## Quick Reference

```bash
# New feature branch worktree
git worktree add ../new-folder -b feature/new

# Existing branch worktree
git worktree add ../new-folder existing-branch

# Remote branch worktree
git worktree add ../new-folder origin/branch-name

# List all worktrees
git worktree list

# Remove worktree
git worktree remove ../folder-name

# Force remove (with changes)
git worktree remove --force ../folder-name

# Cleanup deleted worktrees
git worktree prune
```
