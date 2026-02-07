# Effective Patterns

## Feature Branch Workflow with Atomic Commits
- **scope**: universal
- **discovered**: 2026-02-07
- **project**: leo-claude-plugin
- **use-case**: 여러 파일을 건드리는 리팩토링/기능 작업

### Workflow
1. `/git-master` 호출 -> 스타일 감지 + 커밋 분할 계획
2. 계획대로 `git add` + `git commit` 실행
3. `/git-workflow`로 브랜치 생성 (`refactor/*`, `feature/*` 등)
4. `git push` + `gh pr create`
5. `/code-review`로 diff 검증
6. `gh pr merge` -> `git pull` -> 로컬/리모트 브랜치 정리

### Notes
- 3+ files -> 반드시 2+ commits (git-master hard rule)
- PR 머지 후 브랜치 즉시 삭제 (장기 방치 금지)
- 스킬 간 역할 분담이 핵심: git-master(커밋), git-workflow(브랜치/PR), code-reviewer(검증)
