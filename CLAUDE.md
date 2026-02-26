# CLAUDE.md

Claude Code Plugin 저장소 가이드.

## 코딩 철학 (항상 적용, 언어 무관)
- **Explicit over Clever** — 영리한 코드보다 명확한 코드
- **Fail-Fast** — 에러는 숨기지 않고 즉시 드러나게
- **Self-Documenting** — 주석은 "왜(Why)"만, "무엇(What)"은 코드가 말하게
- **Design First** — 설계 먼저, 키보드는 나중에
- **Proven over Trendy** — 검증된 것이 트렌디한 것보다 낫다

## 범용 규칙
- NEVER: main/master 브랜치에 직접 커밋 (반드시 브랜치 생성 후 PR)
- NEVER: 테스트 없는 커밋, 100줄 넘는 함수, 하드코딩된 시크릿
- ALWAYS: 에러 핸들링 명시, 커밋 메시지 conventional commits
- ALWAYS: 변경 전 기존 테스트 실행
- ALWAYS: 새 스킬/명령어 작성 전 references/ 디렉토리 확인 (중복 방지)
- ALWAYS: Hook/Skill/Command 제안 전 기존 설정 확인 (중복 방지)
- ALWAYS: 3개 이상 파일에서 동일 가이드라인 반복 시 references/로 추출
- ALWAYS: 스킬 분류는 frontmatter 필드 기준 (`user-invocable`, `disable-model-invocation`)
- 함수는 짧게 (20-50줄), 모듈은 200-400줄 목표
- Type/타입 힌트 필수, 테스트 먼저 구현 나중

## 버전 관리

plugin.json의 version 필드는 SemVer를 따른다.
- MAJOR: 스킬/에이전트/커맨드 삭제·이름 변경, 훅 동작 변경 (호환성 파괴)
- MINOR: 새 스킬/에이전트/커맨드/훅 추가
- PATCH: 버그 수정, 문서 수정, 내부 구조 리팩토링
- ALWAYS: PR에 컴포넌트 변경이 포함되면 version 업데이트
- ALWAYS: 머지 후 `claude plugin update`로 캐시 갱신

## Hook 관리
- ALWAYS: Hook 추가 전 글로벌(`~/.claude/settings.json`)과 프로젝트(`hooks/hooks.json`) 중복 확인
- ALWAYS: 프로젝트별 Hook은 프로젝트 hooks.json에, 범용 Hook은 글로벌 설정에 배치
- NOTE: 글로벌/프로젝트 훅이 같은 이벤트+matcher에 등록되면 2중 실행됨 (성능 낭비)

## 개발 환경
- ALWAYS: Visor 사용 시 `full` preset 권장 (최대 컨텍스트)

## 자기 개선
- 세션 종료 전 `/reflect` 실행을 제안할 것
- 반복되는 실수 발견 시 CLAUDE.md 업데이트를 제안할 것
- 3회 이상 같은 파일 수정 시 설계 재검토를 제안할 것

## 구조

```
leo-claude-plugin/
├── .claude-plugin/
│   ├── plugin.json          # 플러그인 메타데이터
│   └── marketplace.json     # 마켓플레이스 카탈로그
├── .mcp.json                # MCP 서버 설정 (향후 확장용)
├── skills/                   # 스킬 (22개)
│   └── <skill-name>/
│       ├── SKILL.md         # 필수: 스킬 정의
│       ├── references/      # 선택: 참조 문서
│       └── assets/          # 선택: 템플릿
├── agents/                   # 커스텀 에이전트 (13개)
│   └── <agent-name>.md
├── commands/                 # 슬래시 명령어 (7개)
│   └── <command-name>.md
├── references/               # 에이전트·명령어 간 공유 참조
├── hooks/                   # 훅 설정 (자동 로드)
│   └── hooks.json
├── templates/               # 프로젝트 스캐폴딩 템플릿
│   └── project/
├── docs/                    # 설계 문서
│   └── architecture.md
└── scripts/
    └── validate.sh
```

## plugin.json 형식

```json
{
  "name": "plugin-name",
  "description": "플러그인 설명",
  "version": "1.0.0",
  "author": {
    "name": "Author",
    "url": "https://github.com/author"
  },
  "keywords": ["keyword1", "keyword2"]
}
```

**디폴트 디렉토리 (자동 로드):**
- `commands/` - 슬래시 명령어
- `agents/` - 커스텀 에이전트
- `skills/` - 스킬
- `hooks/hooks.json` - 훅 설정

**커스텀 경로 (선택):**
```json
{
  "commands": ["./custom/cmd.md"],
  "agents": "./custom/agents/",
  "skills": "./custom/skills/"
}
```
> 커스텀 경로는 디폴트 디렉토리에 **추가**됨 (대체 아님)

## 스킬 정의 형식

YAML frontmatter 필수:

```yaml
---
name: skill-name                    # 64자 이내
description: ...                    # 200자 이내, 트리거 조건 포함
user-invocable: false               # 선택: Claude 자동 호출 전용 (배경 지식형)
disable-model-invocation: true      # 선택: 수동 호출만 허용 (도메인 특화)
argument-hint: "[인자 설명]"          # 선택: 자동완성 시 인자 힌트
---
```

**필드 사용 가이드:**
- `user-invocable: false` — 언어 표준처럼 Claude가 프로젝트 감지 후 자동 로딩하는 스킬
- `disable-model-invocation: true` — OpenSearch처럼 특정 도메인에서만 사용하는 스킬
- `argument-hint` — 코딩 문제 URL, 프로젝트명 등 인자를 받는 스킬

## 에이전트 정의 형식

```yaml
---
name: agent-name
description: "에이전트 설명"
tools: Read, Grep, Glob
disallowedTools: Write, Edit
model: sonnet
permissionMode: plan                # 선택: plan (읽기 전용), bypassPermissions, default
maxTurns: 15                        # 선택: 최대 턴 수
memory: user                        # 선택: user (크로스 세션 학습)
---
```

## 명령어 정의 형식

```yaml
---
name: command-name
description: "명령어 설명"
allowed-tools: Bash, Read, Edit
argument-hint: "[인자 설명]"              # 선택: 자동완성 시 인자 힌트
disable-model-invocation: true            # 선택: 수동 호출만 허용
---
```

## 훅 정의 형식

`hooks/hooks.json` 파일:

```json
{
  "description": "훅 전체 설명",
  "hooks": {
    "<EventType>": [
      {
        "matcher": "ToolName|Pattern",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c '...'",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

**이벤트 타입:** `PreToolUse`, `PostToolUse`, `SessionStart`, `SessionEnd`, `Stop`, `SubagentStart`, `SubagentStop`, `Notification`, `PreCompact` 등
**훅 타입:** `command` (쉘 명령), `prompt` (LLM 판단), `agent` (다중 도구 조사)
**차단:** exit 2 + JSON `{"decision": "block", "reason": "..."}`
**에러 처리:** 도구 없으면 조용히 무시, 있으면 에러 전달 (|| true 남용 금지)

## 컴포넌트 목록

@references/components.md 참조

## 스크립트

```bash
# 전체 검증 (skills, agents, commands, hooks)
./scripts/validate.sh
```

## 새 스킬 추가

1. `skills/new-skill/SKILL.md` 생성
2. YAML frontmatter 작성 (name, description 필수)
3. 500줄 이내로 유지 (초과 시 `references/` 사용)
4. `./scripts/validate.sh`로 검증

## 새 에이전트 추가

1. `agents/new-agent.md` 생성
2. YAML frontmatter 작성 (name, description, tools 필수)
3. 기존 에이전트와 역할 중복 확인 (공유 문서는 최상위 `references/`에 배치)
4. `./scripts/validate.sh`로 검증

## 새 커맨드 추가

1. `commands/new-command.md` 생성
2. YAML frontmatter 작성 (name, description, allowed-tools 필수)
3. Claude Code 네이티브 명령어와 이름 충돌 확인 (`/help`, `/clear`, `/init`, `/doctor` 등)
4. `./scripts/validate.sh`로 검증
