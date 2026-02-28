# Architecture

Claude Code 플러그인 구조 및 설계 결정 기록.

## Plugin vs Marketplace

### 개념 비교

| 타입 | 파일 | 구조 | 용도 |
|------|------|------|------|
| **Plugin** | `plugin.json` | 1 저장소 = 1 플러그인 | 단일 플러그인 배포 |
| **Marketplace** | `marketplace.json` | 1 저장소 = N 플러그인 목록 | 플러그인 카탈로그/인덱스 |

### Plugin (단일 플러그인)

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json      ← 단일 플러그인 정의
├── skills/
├── agents/
├── commands/
├── hooks/
│   └── hooks.json       ← 자동 로드 (v2.1+)
└── templates/            ← 프로젝트 스캐폴딩 템플릿
```

**plugin.json 형식:**

```json
{
  "name": "my-plugin",
  "description": "Plugin description",
  "version": "1.0.0",
  "author": {
    "name": "Author",
    "url": "https://github.com/author"
  },
  "keywords": ["keyword1", "keyword2"]
}
```

**디폴트 디렉토리 자동 로드:**

| 디렉토리 | 용도 | 자동 로드 |
|----------|------|-----------|
| `commands/` | 슬래시 명령어 | O |
| `agents/` | 커스텀 에이전트 | O |
| `skills/` | 스킬 | O |
| `hooks/hooks.json` | 훅 설정 | O |

**커스텀 경로 (선택):** 디폴트 외 추가 경로 필요시만 명시
```json
{
  "commands": ["./custom/cmd.md"],
  "agents": "./custom/agents/",
  "skills": "./custom/skills/"
}
```

**설치**: `/plugin add <url>`

**특징**:
- 설치 시 해당 플러그인의 모든 skills/agents/commands 활성화
- 간단한 구조, 관리 용이

**적합한 경우**:
- 개인용 플러그인
- 특정 프로젝트/팀 전용
- 실질 복잡도가 관리 가능한 수준

### Marketplace (마켓플레이스)

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json  ← 플러그인 목록
```

```json
{
  "name": "my-plugins-marketplace",
  "owner": {
    "name": "User",
    "url": "https://github.com/user"
  },
  "metadata": {
    "description": "Plugin collection",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "python-tools",
      "source": {
        "source": "github",
        "repo": "user/python-tools"
      },
      "description": "Python development tools",
      "version": "1.0.0"
    }
  ]
}
```

**설치**: `/plugin marketplace add <url>` 후 개별 플러그인 선택

**특징**:
- 플러그인들이 각각 별도 저장소에 존재
- 사용자가 필요한 플러그인만 선택 설치 가능

**적합한 경우**:
- 조직에서 승인된 플러그인 목록 관리
- 커뮤니티 플러그인 큐레이션
- 팀별로 다른 플러그인 조합 필요

---

## 현재 구조 결정

### 선택: 단일 Plugin

**결정 이유**:
1. 스킬 수가 적절 (25개, 단 KB 검색 스킬은 동일 패턴의 경량 래퍼)
2. 개인용 도구 모음
3. 관리 단순화

### 도메인 분류

현재 스킬들은 6개 도메인으로 분류됨:

| 도메인 | Skills | 공통 속성 |
|--------|--------|-----------|
| 언어별 표준 | go, python, rust, typescript-standards | `user-invocable: false` |
| Git 워크플로우 | git-master, git-workflow, git-worktree | (기본값) |
| 인프라/도메인 | opensearch-client, opensearch-server, langgraph, python, unix, openclaw, claude-code, codex, rust, deepagents, cloudflare-tunnel, langfuse, k3s, argocd, opentelemetry | `disable-model-invocation: true` |
| 플러그인/메타 | claude-code-standards | `user-invocable: false` |
| 기획/도구 | product-planning, coding-problem-solver | `argument-hint` |

---

## 자기 개선 루프

플러그인의 핵심 가치인 자기 개선 시스템:

```
세션 작업 → 훅 피드백 (자동 포맷/보호)
     ↓
/reflect (세션 회고)
     ↓
docs/MISTAKES.md + docs/PATTERNS.md 업데이트 (scope 태깅)
     ↓
/prune (CLAUDE.md 50줄 이내 유지)
     ↓
/harvest (월 1회, 프로젝트 간 🌍 universal 수집)
     ↓
스킬/훅/규칙 개선 → 다음 세션에 반영
```

### Scope 태깅
- 🌍 **universal**: 프로젝트에 무관하게 적용 가능한 범용 지식
- 📌 **project-only**: 이 프로젝트 고유의 컨텍스트에서만 유효

### 구성 요소별 역할

| 구성 요소 | 역할 |
|-----------|------|
| `/reflect` 커맨드 | 세션 분석, 개선 제안 (최대 5개) |
| `reflector` 에이전트 | 깊은 분석, 패턴/실수 감지 |
| `/harvest` 커맨드 | 프로젝트 간 🌍 universal 수집 |
| `/prune` 커맨드 | CLAUDE.md 가지치기 (50줄 목표) |

---

## 프로젝트 템플릿 시스템

`/init-project` 커맨드가 `templates/project/` 를 기반으로 프로젝트를 스캐폴딩:

```
templates/project/
├── CLAUDE.md              ← 프로젝트 CLAUDE.md 템플릿
├── settings.json          ← .claude/settings.json 템플릿
├── .mcp.json              ← MCP 서버 설정
└── docs/
    ├── CONVENTIONS.md     ← 코딩 컨벤션
    ├── MISTAKES.md        ← 실수 기록
    ├── PATTERNS.md        ← 패턴 기록
    ├── ARCHITECTURE.md    ← ADR
    └── AGENT_TEAM_TEMPLATES.md  ← 에이전트 팀 구성
```

언어별 snippet (`skills/{lang}-standards/references/`)을 템플릿에 병합하여 배포.

---

## 훅 아키텍처

### PostToolUse (파일 편집 후)
- Python: `ruff format`
- Rust: `rustfmt`
- Go: `gofmt`
- TypeScript/JavaScript: `prettier`

### PreToolUse (도구 실행 전)
- **민감 파일 보호**: `.env`, `.pem`, `.key`, `.secret`, `credentials`, `token.json`, `id_rsa` 편집 차단
- **위험 명령 차단**: `rm -rf /`, `sudo`, `chmod 777`, `mkfs`, fork bomb 차단
- **린트 체크**: `git commit` 전 `ruff check` 실행

---

## 마켓플레이스 전환 시점

다음 상황에서 분리 고려:

### 전환 기준

- [ ] 팀/조직에 배포하고 팀별로 다른 스킬 조합 필요
- [ ] 특정 스킬만 오픈소스로 공개
- [x] ~~스킬이 20개 이상으로 증가~~ → 25개 도달. 단, KB 스킬은 경량 래퍼라 실질 복잡도 낮음
- [ ] 스킬별 버전 관리 필요

### 전환 시 구조

```
leo-plugins-marketplace/          ← 마켓플레이스 (카탈로그)
├── .claude-plugin/
│   └── marketplace.json
│
leo-lang-plugin/                  ← 언어별 표준
├── skills/
│   ├── python-standards/
│   ├── rust-standards/
│   ├── typescript-standards/
│   └── go-standards/
│
leo-git-plugin/                   ← 전체팀 공통
├── skills/
│   ├── git-workflow/
│   ├── git-master/
│   └── git-worktree/
│
leo-infra-plugin/                 ← DevOps팀용
├── skills/
│   ├── opensearch-client/
│   └── opensearch-server/
```

---

## 요약

| 상황 | 권장 |
|------|------|
| 개인용, 실질 스킬 < 30개 | 단일 플러그인 (현재) |
| 팀 배포, 권한 분리 | 마켓플레이스 + 도메인별 플러그인 |
| 커뮤니티 배포 | 마켓플레이스 (선택적 설치) |
