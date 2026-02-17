# Leo's Claude Plugin

Claude Code 플러그인. Skills, Agents, Commands, Hooks, Templates 포함.

## 사용 가이드

### 1. 설치

```bash
# 방법 1: 단일 플러그인으로 설치
/plugin add https://github.com/namyoungkim/leo-claude-plugin

# 방법 2: 마켓플레이스로 설치
/plugin marketplace add https://github.com/namyoungkim/leo-claude-plugin
```

> **Plugin vs Marketplace**
> - **Plugin**: 1개 저장소 = 1개 플러그인 (직접 설치)
> - **Marketplace**: 플러그인 카탈로그에서 선택 설치

### 2. 프로젝트 초기화

```bash
/init-project
```

언어(Python/Rust/TypeScript/Go) 선택 → 템플릿 배포:
- `CLAUDE.md`, `docs/`, `.claude/settings.json` 생성
- 언어별 컨벤션, 린터/포맷터 설정 자동 병합

### 3. 일상 개발

- **자동 포맷팅**: `.py`, `.rs`, `.go`, `.ts/.tsx` 파일 편집 시 훅이 자동 포맷
- **보호 훅**: `.env`, `.pem` 등 민감 파일 편집 차단
- **위험 명령 차단**: `rm -rf /`, `sudo`, `chmod 777` 등 차단
- **스킬 자동 트리거**: 언어별 코딩 표준이 컨텍스트에 따라 자동 활성화

### 4. 코드 리뷰

```bash
# 빠른 리뷰 (커맨드)
/code-review

# 깊은 리뷰 (에이전트)
@code-reviewer
```

### 5. 세션 마무리

```bash
/reflect
```

실수/패턴 분석 → `docs/MISTAKES.md`, `docs/PATTERNS.md` 업데이트 제안

### 6. 정기 관리

```bash
# CLAUDE.md 가지치기 (50줄 이내 유지)
/prune

# 프로젝트 간 범용 지식 수집 (월 1회)
/harvest
```

## 구성 요소

### Skills (18개)

| Skill | 설명 |
|-------|------|
| **언어별 표준** | |
| go-standards | Go 코딩 표준 (go mod + golangci-lint + gofmt) |
| python-standards | Python 코딩 표준 (uv + ruff + ty + pytest) |
| rust-standards | Rust 코딩 표준 (cargo + clippy + rustfmt) |
| typescript-standards | TypeScript 코딩 표준 (pnpm + eslint + prettier + vitest) |
| **Git 워크플로우** | |
| git-master | 커밋 아키텍트 + 히스토리 전문가 (커밋/rebase/blame) |
| git-workflow | GitHub Flow 브랜치 전략 + PR 워크플로우 |
| git-worktree | Git worktree 병렬 개발 가이드 |
| **인프라/도메인** | |
| opensearch-client | OpenSearch Python 클라이언트 (텍스트/벡터/하이브리드 검색) |
| opensearch-server | Docker 기반 OpenSearch 서버 관리 (Nori 한국어 분석기) |
| langgraph | LangGraph 지식 베이스 검색 (kb CLI 기반) |
| python | Python 지식 베이스 검색 (kb CLI 기반) |
| unix | Unix 지식 베이스 검색 (kb CLI 기반) |
| openclaw | OpenClaw 지식 베이스 검색 (kb CLI 기반) |
| claude-code | Claude Code 지식 베이스 검색 (kb CLI 기반) |
| codex | OpenAI Codex 지식 베이스 검색 (kb CLI 기반) |
| **플러그인/메타** | |
| claude-code-standards | Claude Code 플러그인 개발 표준 (공식 문서 기반) |
| **기획/도구** | |
| product-planning | 인터뷰 기반 제품/프로젝트 기획 |
| coding-problem-solver | 코딩 인터뷰 문제 풀이 정리 |

### Agents (9개)

| Agent | 설명 |
|-------|------|
| code-reviewer | 코드 리뷰 전문가 (git diff 분석) |
| refactor-assistant | 리팩토링 도우미 |
| reflector | 세션 회고 및 자기 개선 |
| langgraph-master | LangGraph 지식 베이스 전문가 |
| python-master | Python 지식 베이스 전문가 |
| unix-master | Unix 지식 베이스 전문가 |
| openclaw-master | OpenClaw 지식 베이스 전문가 |
| claude-code-master | Claude Code 지식 베이스 전문가 |
| codex-master | OpenAI Codex 지식 베이스 전문가 |

### Commands (7개)

| Command | 설명 |
|---------|------|
| /setup | 개발 환경 초기 설정 |
| /checkup | 환경 진단 및 문제 해결 |
| /reflect | 세션 회고 + 개선 제안 |
| /harvest | 프로젝트 간 지식 수집 |
| /prune | CLAUDE.md 정리 |
| /code-review | 빠른 코드 리뷰 |
| /init-project | 프로젝트 템플릿 배포 |

### Hooks

- **PostToolUse (포맷팅)**: Python(ruff), Rust(rustfmt), Go(gofmt), TypeScript(prettier) 자동 포맷
- **PreToolUse (보호)**: 민감 파일(.env, .pem, credentials) 편집 차단
- **PreToolUse (안전)**: 위험 명령(rm -rf /, sudo, chmod 777) 차단
- **PreToolUse (린트)**: git commit 전 언어별 린트+자동수정 (ruff, clippy, golangci-lint, eslint)

## 구조

```
leo-claude-plugin/
├── .claude-plugin/
│   ├── plugin.json          # 플러그인 메타데이터
│   └── marketplace.json     # 마켓플레이스 카탈로그
├── skills/                   # 스킬 (18개)
│   ├── claude-code/
│   ├── claude-code-standards/
│   ├── codex/
│   ├── coding-problem-solver/
│   ├── git-master/
│   ├── git-workflow/
│   ├── git-worktree/
│   ├── go-standards/
│   ├── langgraph/
│   ├── openclaw/
│   ├── opensearch-client/
│   ├── opensearch-server/
│   ├── product-planning/
│   ├── python/
│   ├── python-standards/
│   ├── rust-standards/
│   ├── typescript-standards/
│   └── unix/
├── agents/                   # 에이전트 (9개)
│   ├── claude-code-master.md
│   ├── code-reviewer.md
│   ├── codex-master.md
│   ├── langgraph-master.md
│   ├── openclaw-master.md
│   ├── python-master.md
│   ├── refactor-assistant.md
│   ├── reflector.md
│   ├── unix-master.md
│   └── references/           # 에이전트 간 공유 참조
├── commands/                 # 슬래시 명령어 (7개)
│   ├── setup.md
│   ├── checkup.md
│   ├── reflect.md
│   ├── harvest.md
│   ├── prune.md
│   ├── code-review.md
│   ├── init-project.md
│   └── references/           # 명령어 간 공유 참조
├── hooks/                    # 훅 설정
│   └── hooks.json
├── templates/                # 프로젝트 스캐폴딩 템플릿
│   └── project/
│       ├── CLAUDE.md
│       ├── settings.json
│       ├── .mcp.json
│       └── docs/
├── docs/                     # 설계 문서
│   └── architecture.md
└── scripts/
    └── validate.sh           # 개발용 검증 스크립트
```

## 개발

```bash
# 스킬 YAML frontmatter 검증
./scripts/validate.sh

# plugin.json 유효성 검사
cat .claude-plugin/plugin.json | jq .

# 로컬 테스트
# ~/.claude/plugins/ 에 심볼릭 링크 생성 후 Claude Code 재시작
```

## 새 스킬 추가

```bash
# 1. 폴더 생성
mkdir skills/new-skill

# 2. SKILL.md 작성
cat > skills/new-skill/SKILL.md << 'EOF'
---
name: new-skill
description: "스킬 설명. 트리거 조건 포함."
---

# New Skill

내용...
EOF

# 3. 검증
./scripts/validate.sh
```

## 라이센스

MIT
