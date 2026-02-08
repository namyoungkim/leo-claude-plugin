---
name: init-project
description: "프로젝트 Claude Code 템플릿 초기화. docs/, CLAUDE.md, settings, 언어별 컨벤션 배포"
allowed-tools: Bash, Read, Write, Edit, AskUserQuestion
argument-hint: "[path] [language]"
disable-model-invocation: true
---

# Init Project

프로젝트에 Claude Code 템플릿을 배포합니다.

## 플러그인 경로

[플러그인 경로 확인](references/plugin-path.md) 참조. 아래의 모든 경로는 PLUGIN_ROOT 기준이다.

## 프로세스

### 1단계: 정보 수집

인자가 주어지면 우선 사용한다:
- `$0` → 프로젝트 경로 (없으면 현재 디렉토리)
- `$1` → 언어 (python / rust / typescript / go)

인자가 없거나 부족하면 사용자에게 질문:
1. **프로젝트 경로**: 현재 디렉토리 또는 지정 경로
2. **언어**: python / rust / typescript / go
3. **프로젝트명**: 디렉토리명 기반 또는 직접 입력

### 2단계: 템플릿 배포

플러그인의 `PLUGIN_ROOT/templates/project/` 디렉토리에서 다음 파일을 프로젝트로 복사:

```
프로젝트/
├── CLAUDE.md                    ← PLUGIN_ROOT/templates/project/CLAUDE.md
├── .claude/
│   └── settings.json            ← PLUGIN_ROOT/templates/project/settings.json
├── .mcp.json                    ← PLUGIN_ROOT/templates/project/.mcp.json
└── docs/
    ├── CONVENTIONS.md            ← PLUGIN_ROOT/templates/project/docs/CONVENTIONS.md
    ├── MISTAKES.md               ← PLUGIN_ROOT/templates/project/docs/MISTAKES.md
    ├── PATTERNS.md               ← PLUGIN_ROOT/templates/project/docs/PATTERNS.md
    ├── ARCHITECTURE.md           ← PLUGIN_ROOT/templates/project/docs/ARCHITECTURE.md
    └── AGENT_TEAM_TEMPLATES.md   ← PLUGIN_ROOT/templates/project/docs/AGENT_TEAM_TEMPLATES.md
```

### 3단계: 언어별 설정 병합

선택한 언어의 snippet을 프로젝트 파일에 병합:
- `PLUGIN_ROOT/skills/{언어}-standards/references/claude-snippet.md` → `CLAUDE.md`에 추가
- `PLUGIN_ROOT/skills/{언어}-standards/references/conventions-snippet.md` → `docs/CONVENTIONS.md`에 추가
- `PLUGIN_ROOT/skills/{언어}-standards/references/settings-snippet.json` → `.claude/settings.json`에 병합

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
