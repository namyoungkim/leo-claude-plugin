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
