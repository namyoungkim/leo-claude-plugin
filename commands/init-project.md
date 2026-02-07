---
description: "프로젝트 Claude Code 템플릿 초기화. docs/, CLAUDE.md, settings, 언어별 컨벤션 배포"
allowed-tools: Bash, Read, Write, Edit, AskUserQuestion
---

# Init Project

프로젝트에 Claude Code 템플릿을 배포합니다.

## 프로세스

### 1단계: 정보 수집

사용자에게 질문:
1. **프로젝트 경로**: 현재 디렉토리 또는 지정 경로
2. **언어**: python / rust / typescript / go
3. **프로젝트명**: 디렉토리명 기반 또는 직접 입력

### 2단계: 템플릿 배포

플러그인의 `templates/project/` 디렉토리에서 다음 파일을 프로젝트로 복사:

```
프로젝트/
├── CLAUDE.md                    ← templates/project/CLAUDE.md 복사 후 프로젝트명 치환
├── .claude/
│   └── settings.json            ← templates/project/settings.json 복사
├── .mcp.json                    ← templates/project/.mcp.json 복사
└── docs/
    ├── CONVENTIONS.md            ← templates/project/docs/CONVENTIONS.md 복사
    ├── MISTAKES.md               ← templates/project/docs/MISTAKES.md 복사
    ├── PATTERNS.md               ← templates/project/docs/PATTERNS.md 복사
    ├── ARCHITECTURE.md           ← templates/project/docs/ARCHITECTURE.md 복사
    └── AGENT_TEAM_TEMPLATES.md   ← templates/project/docs/AGENT_TEAM_TEMPLATES.md 복사
```

### 3단계: 언어별 설정 병합

선택한 언어의 snippet을 프로젝트 파일에 병합:
- `skills/{언어}-standards/references/claude-snippet.md` → `CLAUDE.md`에 추가
- `skills/{언어}-standards/references/conventions-snippet.md` → `docs/CONVENTIONS.md`에 추가
- `skills/{언어}-standards/references/settings-snippet.json` → `.claude/settings.json`에 병합

### 4단계: .gitignore 업데이트

`.gitignore`에 다음 항목이 없으면 추가:
```
.claude/settings.local.json
.env
.env.*
```

### 5단계: 프로젝트 등록 (선택)

사용자에게 `~/.claude/projects.json` 등록 여부 질문.
등록 시 `/harvest` 커맨드에서 이 프로젝트의 지식을 수집할 수 있음.

```json
{
  "projects": [
    {"name": "프로젝트명", "path": "/절대/경로"}
  ]
}
```

## 규칙
- 이미 존재하는 파일은 덮어쓰지 않음 (사용자에게 확인 후 결정)
- 템플릿의 `[프로젝트명]`, `[언어]` 등 플레이스홀더를 실제 값으로 치환
- 모든 파일 생성 후 결과 요약 출력
