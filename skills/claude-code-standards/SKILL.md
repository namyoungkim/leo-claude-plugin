---
name: claude-code-standards
description: "Claude Code 플러그인 프로젝트의 구조, 컴포넌트 형식, 모범 사례 가이드. 공식 문서 기반. 트리거: Claude Code 플러그인, .claude-plugin, plugin.json, SKILL.md, 에이전트, 커맨드, 훅 설정"
user-invocable: false
---

<!-- Last synced: 2026-02-15 | Source: https://code.claude.com/docs (plugins, plugins-reference) -->

# Claude Code Plugin Standards

Claude Code 플러그인 개발을 위한 공식 문서 기반 구조 및 형식 가이드.

## Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json           # 플러그인 매니페스트 (선택)
├── commands/                 # 슬래시 명령어 (레거시; 신규는 skills/ 사용)
│   └── my-command.md
├── agents/                   # 커스텀 에이전트
│   └── my-agent.md
├── skills/                   # 스킬
│   └── my-skill/
│       ├── SKILL.md          # 필수
│       ├── references/       # 상세 참조
│       ├── examples/         # 예시 출력
│       └── scripts/          # 실행 스크립트
├── hooks/                    # 훅 설정
│   ├── hooks.json            # 메인 훅 설정
│   └── *.json                # 추가 훅 파일
├── .mcp.json                 # MCP 서버 정의
├── .lsp.json                 # LSP 서버 설정
├── templates/                # 프로젝트 스캐폴딩
└── scripts/                  # 유틸리티 스크립트
```

**핵심 규칙**: `.claude-plugin/` 안에는 `plugin.json`만 배치. 다른 모든 컴포넌트(commands, agents, skills, hooks)는 플러그인 루트 레벨에 위치.

### Auto-Discovery

디폴트 디렉토리는 `plugin.json` 없이도 자동 로드됨:

| 디렉토리 | 용도 |
|----------|------|
| `commands/` | 슬래시 명령어 |
| `agents/` | 커스텀 에이전트 |
| `skills/` | 스킬 |
| `hooks/hooks.json` | 훅 설정 |

---

## plugin.json Schema

매니페스트는 **선택 사항**. 생략 시 디렉토리명을 플러그인 이름으로 사용하고 디폴트 위치에서 컴포넌트 자동 발견.

### 필수 필드

| 필드 | 타입 | 설명 |
|------|------|------|
| `name` | string | 고유 식별자 (kebab-case, 공백 없음) |

### 메타데이터 필드 (권장)

| 필드 | 타입 | 설명 |
|------|------|------|
| `version` | string | 시맨틱 버전 (MAJOR.MINOR.PATCH) |
| `description` | string | 플러그인 설명 |
| `author` | object | `name`, `email`, `url` |
| `homepage` | string | 문서 URL |
| `repository` | string | 소스 코드 URL |
| `license` | string | 라이선스 식별자 |
| `keywords` | array | 검색 태그 |

### 컴포넌트 경로 필드 (선택)

| 필드 | 타입 | 설명 |
|------|------|------|
| `commands` | string\|array | 추가 명령어 경로 |
| `agents` | string\|array | 추가 에이전트 경로 |
| `skills` | string\|array | 추가 스킬 경로 |
| `hooks` | string\|array\|object | 추가 훅 설정 |
| `mcpServers` | string\|array\|object | MCP 서버 설정 |
| `lspServers` | string\|array\|object | LSP 서버 설정 |
| `outputStyles` | string\|array | 출력 스타일 파일 |

**경로 동작**: 커스텀 경로는 디폴트 디렉토리에 **추가**됨 (대체 아님). 모든 경로는 상대 경로 + `./` 시작 필수.

### 환경 변수

| 변수 | 용도 |
|------|------|
| `${CLAUDE_PLUGIN_ROOT}` | 플러그인 디렉토리 절대 경로. 훅, MCP 서버, 스크립트에서 사용 |

---

## Skills Format

스킬은 `skills/<name>/SKILL.md` 구조. YAML frontmatter로 메타데이터 정의.

### Frontmatter 필드

| 필드 | 필수 | 설명 |
|------|------|------|
| `name` | 아니오 | 표시명. 생략 시 디렉토리명 사용. 소문자+숫자+하이픈, 64자 이내 |
| `description` | 권장 | 스킬 용도 + 트리거 조건. Claude가 자동 적용 판단에 사용 |
| `argument-hint` | 아니오 | 자동완성 힌트. 예: `[issue-number]` |
| `disable-model-invocation` | 아니오 | `true`: Claude 자동 로딩 방지. 수동 호출만 허용 |
| `user-invocable` | 아니오 | `false`: `/` 메뉴에서 숨김. 배경 지식용 |
| `allowed-tools` | 아니오 | 스킬 활성 시 권한 없이 사용 가능한 도구 |
| `model` | 아니오 | 스킬 활성 시 사용할 모델 |
| `context` | 아니오 | `fork`: 포크된 서브에이전트 컨텍스트에서 실행 |
| `agent` | 아니오 | `context: fork` 시 사용할 에이전트 타입 |
| `hooks` | 아니오 | 스킬 라이프사이클에 스코프된 훅 |

### Invocation Control

| Frontmatter | 사용자 호출 | Claude 호출 | 컨텍스트 |
|-------------|-----------|-----------|---------|
| (기본값) | O | O | description 항상 로드, 호출 시 전체 로드 |
| `disable-model-invocation: true` | O | X | description 미로드, 사용자 호출 시 전체 로드 |
| `user-invocable: false` | X | O | description 항상 로드, Claude 호출 시 전체 로드 |

### 문자열 치환

| 변수 | 설명 |
|------|------|
| `$ARGUMENTS` | 호출 시 전달된 모든 인자 |
| `$ARGUMENTS[N]` | 0-기반 인덱스로 특정 인자 접근 |
| `$N` | `$ARGUMENTS[N]` 축약형 |
| `${CLAUDE_SESSION_ID}` | 현재 세션 ID |

### Dynamic Context

`` !`command` `` 구문으로 셸 명령 실행 후 출력을 스킬 콘텐츠에 주입.

### 크기 제한

- SKILL.md는 500줄 이내 유지, 상세 내용은 references/로 분리
- 스킬 description 합계: 컨텍스트 윈도우의 2% (폴백: 16,000자)
- `SLASH_COMMAND_TOOL_CHAR_BUDGET` 환경변수로 한도 조정 가능

---

## Agents Format

에이전트는 `agents/<name>.md` 파일. 각 에이전트는 자체 컨텍스트 윈도우에서 실행.

### Frontmatter 필드

| 필드 | 필수 | 설명 |
|------|------|------|
| `name` | O | 고유 식별자 (소문자+하이픈) |
| `description` | O | Claude가 자동 위임 판단에 사용 |
| `tools` | 아니오 | 사용 가능 도구. 생략 시 전체 상속. `Task(worker, researcher)` 형태로 하위 에이전트 제한 가능 |
| `disallowedTools` | 아니오 | 거부할 도구 |
| `model` | 아니오 | `sonnet`, `opus`, `haiku`, `inherit` (기본: `inherit`) |
| `permissionMode` | 아니오 | `default`, `acceptEdits`, `delegate`, `dontAsk`, `bypassPermissions`, `plan` |
| `maxTurns` | 아니오 | 최대 에이전트 턴 수 |
| `skills` | 아니오 | 시작 시 컨텍스트에 사전 로딩할 스킬 |
| `mcpServers` | 아니오 | 사용 가능 MCP 서버 |
| `hooks` | 아니오 | 에이전트 라이프사이클에 스코프된 훅 |
| `memory` | 아니오 | 크로스 세션 학습: `user`, `project`, `local` |

### Permission Modes

| 모드 | 동작 |
|------|------|
| `default` | 표준 권한 확인 |
| `acceptEdits` | 파일 편집 자동 승인 |
| `dontAsk` | 권한 프롬프트 자동 거부 (명시 허용 도구만 동작) |
| `delegate` | 에이전트 팀 리드용 조율 전용 모드 |
| `bypassPermissions` | 모든 권한 체크 생략 |
| `plan` | 읽기 전용 탐색 모드 |

### Memory Scopes

| 스코프 | 위치 | 용도 |
|--------|------|------|
| `user` | `~/.claude/agent-memory/<name>/` | 전체 프로젝트 간 학습 |
| `project` | `.claude/agent-memory/<name>/` | 프로젝트별, 버전관리 공유 |
| `local` | `.claude/agent-memory-local/<name>/` | 프로젝트별, gitignore |

메모리 활성화 시 `MEMORY.md` 첫 200줄이 에이전트 프롬프트에 포함됨.

---

## Commands Format

`commands/<name>.md` 파일. 스킬의 레거시 형식이며, 동일 이름의 스킬이 있으면 스킬이 우선.

### Frontmatter 필드

스킬과 동일한 필드를 지원:
`name`, `description`, `argument-hint`, `disable-model-invocation`, `user-invocable`, `allowed-tools`, `model`, `context`, `agent`, `hooks`

---

## Hooks Format

훅은 Claude Code 라이프사이클의 특정 시점에서 자동 실행되는 핸들러.

### 설정 위치

| 위치 | 스코프 |
|------|--------|
| `~/.claude/settings.json` | 전체 프로젝트 |
| `.claude/settings.json` | 단일 프로젝트 (커밋 가능) |
| `.claude/settings.local.json` | 단일 프로젝트 (gitignore) |
| 플러그인 `hooks/hooks.json` | 플러그인 활성 시 |
| 스킬/에이전트 frontmatter | 컴포넌트 활성 시 |

### 이벤트 타입 요약

| 이벤트 | 차단 가능 | Matcher |
|--------|----------|---------|
| `SessionStart` | X | `startup`, `resume`, `clear`, `compact` |
| `UserPromptSubmit` | O | (없음) |
| `PreToolUse` | O | 도구명 |
| `PermissionRequest` | O | 도구명 |
| `PostToolUse` | X | 도구명 |
| `PostToolUseFailure` | X | 도구명 |
| `Notification` | X | 알림 타입 |
| `SubagentStart` | X | 에이전트 타입 |
| `SubagentStop` | O | 에이전트 타입 |
| `Stop` | O | (없음) |
| `TeammateIdle` | O | (없음) |
| `TaskCompleted` | O | (없음) |
| `PreCompact` | X | `manual`, `auto` |
| `SessionEnd` | X | 종료 이유 |

> 상세 스펙은 `references/hooks-reference.md` 참조.

### Hook Types

| 타입 | 설명 |
|------|------|
| `command` | 셸 명령 실행. `timeout`, `statusMessage`, `once`, `async` 지원 |
| `prompt` | LLM에 프롬프트 전달하여 판단. `model`, `timeout` 지원 |
| `agent` | 다중 도구(Read, Grep, Glob) 사용 가능한 에이전트 조사. 최대 50턴 |

### Exit Code 동작

| Exit Code | 동작 |
|-----------|------|
| 0 | 성공. stdout에서 JSON 파싱 |
| 2 | 차단. stderr를 피드백으로 전달 |
| 기타 | 비차단 에러. verbose 모드에서 stderr 표시 |

---

## MCP Servers

`.mcp.json` 파일 또는 `plugin.json`의 `mcpServers` 필드로 정의.

```json
{
  "mcpServers": {
    "server-name": {
      "command": "path/to/server",
      "args": ["--flag", "value"],
      "env": { "KEY": "value" }
    }
  }
}
```

### 전송 방식

| 방식 | 권장 | 용도 |
|------|------|------|
| HTTP | O (권장) | 원격 서버 |
| SSE | X (deprecated) | 레거시 |
| stdio | - | 로컬 서버 |

### 환경변수 확장

`.mcp.json`에서 `${VAR}`, `${VAR:-default}` 구문 지원. `command`, `args`, `env`, `url`, `headers`에서 사용 가능.

### 플러그인 MCP 서버

- `${CLAUDE_PLUGIN_ROOT}`로 플러그인 상대 경로 지정
- 플러그인 활성화 시 자동 시작

---

## LSP Servers

`.lsp.json` 파일로 정의. 언어 서버 진단(타입 에러, 린트)을 Claude에 제공.

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": { ".go": "go" }
  }
}
```

필수: `command`, `extensionToLanguage`. 선택: `args`, `transport`, `env`, `initializationOptions`, `settings`, `restartOnCrash`.

---

## Best Practices

### 구조
- `.claude-plugin/` 안에는 `plugin.json`만 배치
- 모든 경로는 상대 경로 + `./` 시작
- 이름은 kebab-case (소문자, 숫자, 하이픈만)
- 시맨틱 버전 관리 (MAJOR.MINOR.PATCH)

### 스킬
- SKILL.md는 500줄 이내, 초과 시 references/ 사용
- description에 트리거 조건을 포함하여 Claude 자동 판단 지원
- 부작용이 있는 워크플로우는 `disable-model-invocation: true`
- 배경 지식형은 `user-invocable: false`

### 에이전트
- 에이전트 하나당 단일 전문 역할
- 도구 접근은 필요 최소한으로 제한
- 프로젝트 에이전트는 버전 관리에 포함
- 크로스 프로젝트 학습이 필요하면 `memory: user`

### 훅
- 입력 검증 및 위생 처리
- 셸 변수는 항상 따옴표로 감싸기
- 경로 순회(path traversal) 차단
- `$CLAUDE_PROJECT_DIR`로 절대 경로 구성
- Stop 훅에서 `stop_hook_active` 체크 (무한 루프 방지)
- 스크립트에 shebang 라인 + `chmod +x` 필수
- 배포 전 수동 테스트

### MCP 서버
- 원격 서버는 HTTP 전송 사용 (권장)
- 플러그인 번들 서버는 `${CLAUDE_PLUGIN_ROOT}` 사용
- `MCP_TIMEOUT`으로 적절한 타임아웃 설정

---

## Common Mistakes (Quick Reference)

> 상세 증상/원인/해결은 `references/common-mistakes.md` 참조.

| 실수 | 올바른 방법 |
|------|------------|
| 컴포넌트를 `.claude-plugin/` 안에 배치 | 플러그인 루트 레벨에 배치 |
| 절대 경로 사용 | `./` 시작 상대 경로 사용 |
| frontmatter `---` 누락 | 파일 첫 줄과 종료 줄에 `---` 필수 |
| description에 콜론 미인용 | 콜론 포함 시 반드시 따옴표 감싸기 |
| 훅 스크립트 +x 미설정 | `chmod +x` + shebang 라인 |
| 이벤트명 대소문자 오류 | PascalCase 정확히 사용 (예: `PreToolUse`) |
| 네이티브 명령어와 이름 충돌 | `/help`, `/clear`, `/init` 등 예약어 회피 |

---

## Audit Checklist

플러그인 프로젝트 검증용 체크리스트:

### 구조
- [ ] `.claude-plugin/`에 `plugin.json`만 존재
- [ ] 컴포넌트 디렉토리(skills, agents, commands, hooks)가 루트 레벨에 위치
- [ ] 모든 커스텀 경로가 `./`로 시작하는 상대 경로

### plugin.json
- [ ] `name` 필드 존재 (kebab-case)
- [ ] `version` 필드 시맨틱 버전 형식
- [ ] 커스텀 경로 필드의 타입이 string 또는 array

### Skills
- [ ] 각 스킬이 `skills/<name>/SKILL.md` 구조
- [ ] YAML frontmatter 유효 (--- 시작/끝)
- [ ] `name` 64자 이내, 소문자+숫자+하이픈
- [ ] `description` 200자 이내, 트리거 조건 포함
- [ ] SKILL.md 500줄 이내 (초과 시 references/ 분리)
- [ ] invocation control 설정이 용도에 맞음

### Agents
- [ ] `name`, `description` 필수 필드 존재
- [ ] `tools` 목록이 역할에 필요한 최소한으로 제한
- [ ] `permissionMode`가 용도에 적합
- [ ] `maxTurns` 설정 (무한 실행 방지)

### Commands
- [ ] `name` 필수 필드 존재
- [ ] Claude Code 네이티브 명령어와 이름 미충돌
- [ ] 동일 이름의 스킬과 중복 없음 (스킬이 우선)

### Hooks
- [ ] `hooks.json` JSON 문법 유효
- [ ] 이벤트명이 정확한 PascalCase
- [ ] 차단 로직에 exit 2 사용
- [ ] 셸 변수 따옴표 처리
- [ ] Stop 훅에 `stop_hook_active` 무한 루프 방지

### MCP/LSP
- [ ] `.mcp.json`에서 `${CLAUDE_PLUGIN_ROOT}` 사용 (플러그인 번들 시)
- [ ] `.lsp.json`에 `command`, `extensionToLanguage` 필수 필드 존재
