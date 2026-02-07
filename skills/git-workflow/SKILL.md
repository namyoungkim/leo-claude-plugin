---
name: git-workflow
description: "GitHub Flow 브랜치 전략 및 PR 워크플로우. 브랜치 생성부터 PR 머지까지의 전체 플로우 관리. 트리거: branch, 브랜치, PR, pull request, merge, 머지, feature 구현, 새 기능 시작"
---

# Git Workflow (GitHub Flow)

## Branch Strategy

| Branch | Role |
|--------|------|
| `main` | Always deployable, triggers auto-deploy |
| Work branches | `feature/*`, `fix/*`, `refactor/*`, `docs/*`, `chore/*` |

## Branch Naming

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feature/` | New feature | `feature/watchlist-export` |
| `fix/` | Bug fix | `fix/login-redirect` |
| `refactor/` | Code refactoring | `refactor/api-structure` |
| `docs/` | Documentation | `docs/api-guide` |
| `chore/` | Config/maintenance | `chore/update-deps` |

## Workflow

### 1. Create Branch
```bash
git checkout main
git pull origin main
git checkout -b feature/new-feature
```

### 2. Develop & Commit
```bash
git add .
git commit -m "feat: add feature description"
```

### 3. Push & Create PR
```bash
git push -u origin feature/new-feature
gh pr create --title "feat: description" --body "## Summary\n- Changes"
```

### 4. Merge & Cleanup
```bash
gh pr merge --merge
git checkout main
git pull
git branch -d feature/new-feature
```

## Commit Message Format

> 커밋 메시지 형식은 **git-master** 스킬에서 관리한다.
> Conventional Commits 기반: `<type>: <subject>`

## Branch Protection (main)

main 브랜치에 직접 push 금지, PR을 통해서만 머지.

### GitHub 웹에서 설정

Settings > Branches > Add rule:
- Branch name pattern: `main`
- [x] Require a pull request before merging

### gh CLI로 설정

```bash
gh api repos/{owner}/{repo}/branches/main/protection -X PUT \
  -H "Accept: application/vnd.github+json" \
  --input - <<'EOF'
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismiss_stale_reviews": false,
    "require_code_owner_reviews": false,
    "required_approving_review_count": 0
  },
  "restrictions": null
}
EOF
```

### 보호 규칙 확인

```bash
gh api repos/{owner}/{repo}/branches/main/protection
```

## Exceptions

- Typos, single-line fixes: ~~direct commit to `main` allowed~~ PR 필수
- No `dev` branch needed (Preview deployment serves as staging)

