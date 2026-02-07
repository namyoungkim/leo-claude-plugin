---
description: "세션 회고 및 자기 개선. 실수/패턴 분석 후 CLAUDE.md, hooks, docs/ 개선안 제안"
allowed-tools: Bash, Read, Edit, Grep, Glob, AskUserQuestion
---

# Session Reflection

이번 세션을 회고하고 시스템을 개선해줘.

## 분석 대상
1. 이번 세션의 채팅 히스토리
2. 현재 CLAUDE.md (글로벌 + 프로젝트)
3. `docs/MISTAKES.md` (있다면)
4. `docs/PATTERNS.md` (있다면)
5. `.claude/settings.json`의 hooks와 permissions

## 분석 항목
- 이번 세션에서 발생한 실수나 비효율
- 반복된 패턴 (좋은 것과 나쁜 것 모두)
- Hook으로 자동화할 수 있었던 수동 작업
- CLAUDE.md에 추가하면 다음에 도움될 규칙
- Permissions에서 추가/제거가 필요한 항목

## Scope 태깅 (역수집 연계)

docs/PATTERNS.md 또는 docs/MISTAKES.md에 항목을 추가할 때, 반드시 **scope**를 판단하여 태깅한다.

### 판단 기준
- 🌍 **universal**: 이 프로젝트에 국한되지 않는 범용 지식. 같은 언어의 다른 프로젝트에서도 동일하게 적용 가능.
  - 예: 에러 핸들링 패턴, 린터/포맷터 설정, 테스트 구조화, 타입 시스템 활용
- 📌 **project-only**: 이 프로젝트의 특수한 컨텍스트에서만 유효한 지식.
  - 예: 특정 API의 quirk, 프로젝트 고유 비즈니스 로직, 특정 DB 스키마 관련

### 기록 형식

PATTERNS.md에 추가 시:
```markdown
## 패턴 이름
- **scope**: 🌍 universal
- **발견일**: YYYY-MM-DD
- **프로젝트**: {현재 프로젝트명}
- **용도**: 언제 사용하는가
- **코드 예시**: (코드 블록)
- **주의사항**: 사용 시 유의할 점
```

MISTAKES.md에 추가 시:
```markdown
### [YYYY-MM-DD] 제목
- **scope**: 🌍 universal
- **프로젝트**: {현재 프로젝트명}
- **상황**: 무엇을 하다가 문제가 발생했는가
- **원인**: 근본 원인은 무엇이었는가
- **교훈**: 앞으로 어떻게 해야 하는가 (ALWAYS/NEVER 형태)
- **관련 파일**: 해당 파일 경로
```

### 판단 팁
- "같은 언어의 다른 프로젝트에서도 적용 가능"하면 → 🌍 universal
- "이 프로젝트의 특정 도메인/API/인프라"에 해당하면 → 📌 project-only
- 확신이 없으면 → 🌍 universal로 태깅 (나중에 /harvest에서 걸러짐)

## 출력 형식
각 제안에 대해:
1. **발견**: 무엇을 관찰했는가
2. **제안**: 구체적인 변경 내용
3. **대상 파일**: 어떤 파일을 수정하는가
4. **이유**: 이 변경이 미래 세션을 어떻게 개선하는가

## 규칙
- 사람의 승인을 받은 후에만 실제 파일을 수정할 것
- 제안은 최대 5개까지, 가장 임팩트 높은 순으로 정렬
- Hook 추가 제안 시 settings.json의 구체적 JSON도 함께 제시
- 새 규칙 제안 시 NEVER/ALWAYS 형태의 한 줄로 작성
- **docs/ 항목 추가 시 반드시 scope 태깅을 포함할 것**
