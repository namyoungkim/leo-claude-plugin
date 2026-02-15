# Common Mistakes

Claude Code 플러그인 개발 시 자주 발생하는 실수 카탈로그. 증상 → 원인 → 해결 구조.

---

## 구조 실수

### 컴포넌트를 .claude-plugin/ 안에 배치

**증상**: 스킬/에이전트/커맨드가 로드되지 않음
**원인**: `.claude-plugin/` 안에 `skills/`, `agents/` 등을 배치
**해결**: `.claude-plugin/`에는 `plugin.json`만 배치. 모든 컴포넌트는 플러그인 루트 레벨에 위치

```
# 잘못됨
.claude-plugin/
├── plugin.json
├── skills/          ← 여기에 넣으면 안됨
└── agents/          ← 여기에 넣으면 안됨

# 올바름
.claude-plugin/
└── plugin.json
skills/              ← 루트 레벨
agents/              ← 루트 레벨
```

### 스킬 디렉토리 구조 오류

**증상**: 스킬이 인식되지 않음
**원인**: `skills/my-skill.md`처럼 파일만 생성 (디렉토리 없이)
**해결**: `skills/<name>/SKILL.md` 구조 필수

```
# 잘못됨
skills/my-skill.md

# 올바름
skills/my-skill/SKILL.md
```

---

## 경로 실수

### 절대 경로 사용

**증상**: 다른 환경에서 플러그인이 작동하지 않음
**원인**: `plugin.json`에 절대 경로 사용
**해결**: `./` 시작 상대 경로 사용. 훅/스크립트에서는 `${CLAUDE_PLUGIN_ROOT}` 활용

```json
// 잘못됨
{ "skills": "/Users/me/plugin/extra-skills/" }

// 올바름
{ "skills": "./extra-skills/" }
```

### ./ 접두사 누락

**증상**: 커스텀 경로가 인식되지 않음
**원인**: 상대 경로에 `./` 접두사 없이 직접 디렉토리명 사용
**해결**: 모든 커스텀 경로는 `./`로 시작

```json
// 잘못됨
{ "commands": "custom/cmd.md" }

// 올바름
{ "commands": "./custom/cmd.md" }
```

---

## Frontmatter 실수

### --- 구분자 누락

**증상**: frontmatter가 파싱되지 않아 스킬/에이전트 메타데이터 무시
**원인**: 파일 첫 줄에 `---` 없음, 또는 종료 `---` 누락
**해결**: 파일 첫 줄(BOM 없이) `---`로 시작, frontmatter 끝에 `---`로 종료

### description에 콜론 미인용

**증상**: YAML 파싱 에러
**원인**: description 값에 콜론(`:`)이 포함되었지만 따옴표 없음
**해결**: 콜론 포함 시 반드시 따옴표 감싸기

```yaml
# 잘못됨
description: Python 코딩 표준: uv + ruff 기반

# 올바름
description: "Python 코딩 표준: uv + ruff 기반"
```

### name에 대문자/공백 사용

**증상**: 스킬/에이전트가 정상 동작하지 않음
**원인**: `name`에 대문자, 공백, 또는 특수 문자 사용
**해결**: 소문자, 숫자, 하이픈만 사용 (kebab-case)

```yaml
# 잘못됨
name: My Skill
name: mySkill

# 올바름
name: my-skill
```

---

## 훅 실수

### 이벤트명 대소문자 오류

**증상**: 훅이 발동하지 않음
**원인**: 이벤트명을 소문자/snake_case로 작성
**해결**: 정확한 PascalCase 사용

```json
// 잘못됨
{ "pre_tool_use": [...] }
{ "pretooluse": [...] }

// 올바름
{ "PreToolUse": [...] }
```

### 스크립트 실행 권한 누락

**증상**: `Permission denied` 에러
**원인**: 훅에서 호출하는 스크립트에 실행 권한 없음
**해결**: `chmod +x script.sh` + shebang 라인 추가

```bash
#!/bin/bash
# scripts/check.sh — 반드시 shebang 포함
```

### Stop 훅에서 무한 루프

**증상**: Claude가 멈추지 않고 계속 응답
**원인**: Stop 훅이 `stop_hook_active` 체크 없이 항상 `decision: "block"` 반환
**해결**: 입력의 `stop_hook_active` 필드 체크

```bash
# stop_hook_active가 true이면 차단하지 않음
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi
```

### || true 남용

**증상**: 에러가 조용히 무시되어 디버깅 곤란
**원인**: 모든 훅 명령에 `|| true` 추가
**해결**: 도구가 없는 경우만 조용히 무시. 존재하는 도구의 에러는 전달

---

## 명령어 실수

### 네이티브 명령어와 이름 충돌

**증상**: 커스텀 명령어 대신 네이티브 기능이 실행
**원인**: `/help`, `/clear`, `/init`, `/doctor` 등 예약어와 동일한 이름 사용
**해결**: 예약어 목록 확인 후 고유한 이름 사용

### 스킬과 명령어 중복

**증상**: 명령어 내용이 무시됨
**원인**: 동일 이름의 스킬과 명령어가 존재
**해결**: 동일 이름 시 스킬이 우선. 하나만 유지하거나 이름 변경
