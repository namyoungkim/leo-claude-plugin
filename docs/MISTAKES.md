# Mistakes Log

### [2026-02-07] main 브랜치 직접 커밋 후 브랜치 이동
- **scope**: universal
- **project**: leo-claude-plugin
- **situation**: /reflect 결과를 적용하면서 4개 파일을 수정하고 커밋할 때 브랜치 생성을 깜빡함
- **cause**: 작업 흐름에 집중하다 보니 현재 브랜치 확인을 놓침
- **lesson**:
  - ALWAYS: 첫 커밋 전 `git branch --show-current` 확인
  - ALWAYS: 여러 파일 변경 시 브랜치 생성부터 시작
  - 발견 즉시 `git reset --soft HEAD~N` + 브랜치 생성 + 재커밋으로 복구
- **related**: skills/git-workflow/SKILL.md, skills/git-master/SKILL.md

### [2026-02-08] Hook에서 `command -v && tool` 패턴이 exit 1 반환
- **scope**: 🌍 universal
- **project**: leo-claude-plugin
- **situation**: SessionStart 훅과 PostToolUse 포맷터 4건이 startup hook error를 발생시킴
- **cause**: `command -v tool && tool <args>`에서 tool 미설치 시 `command -v`의 exit 1이 `if` 블록/스크립트 종료 코드가 됨. Claude Code는 non-zero exit를 에러로 해석
- **lesson**:
  - NEVER: `command -v tool && tool` 패턴을 hook에서 사용 (미설치 시 exit 1)
  - ALWAYS: `if command -v tool; then tool; fi` 패턴 사용 (미설치=exit 0, 실패=전달)
  - ALWAYS: hook 작성 후 validate.sh로 exit code 검증
- **related**: hooks/hooks.json, scripts/validate.sh
