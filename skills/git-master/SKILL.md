---
name: git-master
description: "커밋 아키텍트 + 히스토리 전문가. Atomic commit 분할, rebase/squash, blame/bisect 등 커밋과 히스토리 작업 전담. 트리거: commit, 커밋, rebase, squash, blame, bisect, 히스토리 검색, 커밋 분할"
---

# Git Master Agent

Expert combining: **Commit Architect** (atomic commits), **Rebase Surgeon** (history rewriting), **History Archaeologist** (finding when/where changes occurred).

---

## MODE DETECTION (FIRST)

| Request Pattern | Mode |
|-----------------|------|
| commit, 커밋 | COMMIT |
| rebase, squash, cleanup | REBASE |
| find when, blame, bisect | HISTORY_SEARCH |

---

## CORE: MULTIPLE COMMITS BY DEFAULT

**HARD RULES:**
- 3+ files → MUST be 2+ commits
- 5+ files → MUST be 3+ commits
- 10+ files → MUST be 5+ commits

**SPLIT BY:**
- Different directories/modules
- Different component types
- Different concerns (UI/logic/config/test)
- Can be reverted independently

**ONLY COMBINE when:**
- Same atomic unit (implementation + its test)
- Splitting would break compilation

---

## PHASE 0: Context Gathering (자동 주입)

아래 정보가 스킬 호출 시 자동으로 제공된다:

!`git status --short`

!`git diff --staged --stat`

!`git log -30 --oneline`

!`git branch --show-current`

---

## PHASE 1: Style Detection

Analyze git log -30 for:
- **Language**: Korean vs English (use majority)
- **Style**: SEMANTIC (`feat:`) | PLAIN | SHORT

**OUTPUT REQUIRED:**
```
STYLE: [LANGUAGE] + [STYLE]
Examples from repo:
  1. "actual commit message"
  2. "actual commit message"
```

---

## PHASE 2: Commit Plan

**MANDATORY OUTPUT:**
```
COMMIT PLAN
===========
Files: N → Min commits: ceil(N/3)

COMMIT 1: [message]
  - file1.py
  - file1_test.py
  Justification: implementation + test

COMMIT 2: [message]
  - config.py
```

---

## PHASE 3: Execution

```bash
# For each commit
git add <files>
git commit -m "<message-in-detected-style>"
```

**Footer (optional):**
```bash
git commit -m "message" \
  -m "Ultraworked with Dokkaebi" \
  -m "Co-authored-by: Dokkaebi <dokkaebi@example.com>"
```

---

## PHASE 4: Verification

커밋 완료 후 반드시 확인:

```bash
git log --oneline main..HEAD
git status
```

각 커밋이 계획대로 생성되었는지, working tree가 clean한지 검증.
잘못된 커밋 발견 시 `git reset --soft HEAD~1`로 되돌리고 재실행.

---

## 커밋 재구성 (Soft Reset Pattern)

이미 커밋했지만 논리적 분할이 아쉬울 때:

```bash
git log --oneline -3                  # 현재 커밋 구조 확인
git reset --soft HEAD~N               # N개 커밋을 unstage (작업 내용 유지)
git status                            # 변경사항 확인
# 새로운 논리 단위로 재분할
git add <files-for-commit-1>
git commit -m "..."
git add <files-for-commit-2>
git commit -m "..."
```

**사용 시나리오:**
- 커밋 메시지가 모호할 때
- 하나의 큰 커밋을 논리적 단위로 분리할 때
- PR 리뷰어 피드백 반영 시

---

## REBASE MODE

```bash
# Squash all into one
MERGE_BASE=$(git merge-base HEAD main)
git reset --soft $MERGE_BASE
git commit -m "Combined: <summary>"

# Autosquash fixups
GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash $MERGE_BASE
```

---

## HISTORY SEARCH MODE

```bash
# Find who/when
git blame <file>
git log -S "<search-term>" --oneline
git bisect start
git bisect bad HEAD
git bisect good <known-good-commit>
```

---

## Anti-Patterns

- ONE commit for 3+ files
- Grouping by "related to X" (too vague)
- Separating test from implementation
- Default to semantic commits without checking log

## Commit Message Format

커밋 메시지 형식의 정의는 이 스킬이 관리한다.

```
<type>: <subject>

<body> (optional)
```

### Types

| Type | Purpose |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Refactoring (no behavior change) |
| `docs` | Documentation only |
| `chore` | Config, deps, build |
| `test` | Add/modify tests |
| `style` | Formatting, semicolons |
| `perf` | Performance improvement |

### Examples

```bash
feat: add watchlist CSV export
fix: resolve login redirect issue
refactor: simplify API response handler
```
