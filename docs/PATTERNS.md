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

## 커밋 후 즉시 검증 (PHASE 4 패턴)
- **scope**: universal
- **discovered**: 2026-02-07
- **project**: leo-claude-plugin
- **use-case**: 복수 커밋 작업 후 실수 조기 감지

### Code
```bash
git log --oneline main..HEAD  # 생성된 커밋 확인
git status                     # working tree clean 확인
```

### Notes
- 잘못된 커밋 발견 시 즉시 `git reset --soft HEAD~1`로 되돌리고 재실행
- 3개 이상 커밋 작업 시 반드시 적용

## Hook 배치 전략 — 차단 vs 리마인더
- **scope**: universal
- **discovered**: 2026-02-07
- **project**: leo-claude-plugin
- **use-case**: Hook 설계 시 "차단할 것인가, 권장만 할 것인가" 판단

### Strategy

| 시나리오 | 이벤트 | 동작 | 예시 |
|---------|--------|------|------|
| 복구 불가능한 실수 | PreToolUse | 차단 (exit 2) | main 직접 커밋, 민감 파일 수정 |
| 복구 가능하지만 비용 큰 실수 | PreToolUse | 경고 (stdout) | 린트 에러, 테스트 실패 |
| 학습/개선 기회 | Stop | 리마인더 (info) | /reflect 안내 |

### Notes
- `exit 2` 차단은 신중하게 (false positive 가능성 고려)
- 리마인더는 강제하지 않음 (사용자 판단 존중)
- 사용자 자율성 vs 안전성 균형이 핵심

## 공유 참조 패턴 (references/)
- **scope**: universal
- **discovered**: 2026-02-08
- **project**: leo-claude-plugin
- **use-case**: 여러 스킬/명령어에서 반복되는 가이드라인/명령어

### Pattern
```
commands/
├── references/
│   └── shared-knowledge.md
├── cmd-a.md                     # [참조](references/shared-knowledge.md)
└── cmd-b.md                     # [참조](references/shared-knowledge.md)
```

### Benefits
- 중복 제거로 유지보수 포인트 감소 (Single Source of Truth)
- 업데이트 시 단일 지점 수정
- 각 파일 500줄 제한 준수 용이

### Example
PR #21에서 3개 파일의 PLUGIN_ROOT 탐색 로직을 `commands/references/plugin-path.md`로 통합.

### Notes
- `skills/`, `agents/`, `commands/` 모두 `references/` 서브디렉토리 사용 가능
- 공유 범위에 따라 적절한 위치 선택

## Hook Exit Code 보장 패턴
- **scope**: 🌍 universal
- **discovered**: 2026-02-08
- **project**: leo-claude-plugin
- **use-case**: Claude Code hook에서 non-blocking 명령이 의도치 않게 exit 1을 반환하는 버그 방지

### Problem
`command -v tool && tool <args>` 패턴은 tool이 미설치일 때 `command -v`의 exit 1이 스크립트 종료 코드가 된다.
Claude Code는 exit 0 = 성공, exit 2 = 차단, 그 외 = 에러로 해석한다.

### Pattern

| 의도 | 나쁜 패턴 | 좋은 패턴 |
|------|----------|----------|
| 미설치 무시, 실패 전달 | `command -v tool && tool <args>` | `if command -v tool; then tool <args>; fi` |
| 미설치 무시, 실패도 무시 | `command -v tool && tool <args>; exit 0` | `command -v tool && tool <args> \|\| true` |
| 조건부 출력 (마지막이 false) | `[[ -n "$VAR" ]] && echo "$VAR"` | `[[ -n "$VAR" ]] && echo "$VAR"; exit 0` |

### Rule
- ALWAYS: non-blocking hook은 정상 경로에서 exit 0을 보장해야 함
- ALWAYS: 차단 hook만 exit 2를 사용, 그 외 non-zero는 전부 에러 취급

### Notes
- `if/fi` 구조가 `&& \|\| true`보다 의도가 명확
- `; exit 0`은 포맷터 실패도 삼키므로 주의 (SessionStart처럼 출력만 하는 경우에 적합)
- validate.sh에 exit code smoke test 추가하여 회귀 방지

## Graceful Degradation for Agent Edge Cases
- **scope**: 🌍 universal
- **discovered**: 2026-02-08
- **project**: leo-claude-plugin
- **use-case**: 에이전트가 전제 조건이 충족되지 않은 상태에서 호출될 때

### Pattern
에이전트는 핵심 전제가 성립하지 않을 때를 감지해야 한다:
- Reflector: 세션에 분석할 활동이 있는지 확인
- Code-reviewer: git diff가 존재하는지 확인
- Refactor-assistant: 대상 코드가 존재하는지 확인

### Implementation
1. 전제 조건 확인 (tool 호출 횟수, 파일 변경 여부 등)
2. 미충족 시: graceful하게 인지 + 대안 제안
3. 강제 실행 대신 조기 종료

### Benefits
- 빈 세션/누락된 의존성에 대한 더 나은 UX
- 에이전트 목적의 명확한 전달
- 허위 제안(false-positive suggestions) 감소
