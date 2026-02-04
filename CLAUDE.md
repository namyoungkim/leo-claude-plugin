# CLAUDE.md

Claude Code Plugin 저장소 가이드.

## 구조

```
leo-claude-plugin/
├── .claude-plugin/
│   ├── plugin.json          # 필수: 플러그인 메타데이터
│   └── marketplace.json     # 선택: 마켓플레이스 카탈로그
├── skills/                   # 스킬 (8개)
│   └── <skill-name>/
│       ├── SKILL.md         # 필수: 스킬 정의
│       ├── references/      # 선택: 참조 문서
│       └── assets/          # 선택: 템플릿
├── agents/                   # 커스텀 에이전트 (2개)
│   └── <agent-name>.md
├── commands/                 # 슬래시 명령어 (2개)
│   └── <command-name>.md
├── hooks/                   # 훅 설정 (자동 로드)
│   └── hooks.json
├── docs/                    # 설계 문서
│   └── architecture.md      # 플러그인 구조, 마켓플레이스 패턴
└── scripts/
    └── validate.sh          # 개발용 검증 (plugin.json, skills, agents, commands, hooks)
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
name: skill-name          # 64자 이내
description: ...          # 200자 이내, 트리거 조건 포함
---
```

## 에이전트 정의 형식

```yaml
---
name: agent-name
description: "에이전트 설명"
tools: Read, Grep, Glob
disallowedTools: Write, Edit
model: sonnet
---
```

## 명령어 정의 형식

```yaml
---
description: "명령어 설명"
allowed-tools: Bash, Read, Edit
---
```

## Available Skills

- **coding-problem-solver**: 코딩 인터뷰 문제 풀이
- **git-master**: Atomic commits, rebase/squash, history search
- **git-workflow**: GitHub Flow, 커밋 컨벤션, PR 워크플로우
- **git-worktree**: Git worktree 병렬 개발
- **opensearch-client**: OpenSearch Python 클라이언트
- **opensearch-server**: Docker 기반 OpenSearch 서버
- **product-planning**: Impact Mapping, User Story Mapping, C4 Model, ADR
- **python-project**: Python 프로젝트 (uv + ruff + ty + pytest)

## Available Agents

- **code-reviewer**: 코드 리뷰 (읽기 전용)
- **refactor-assistant**: 리팩토링 도우미

## Available Commands

- **/setup**: 개발 환경 초기 설정
- **/doctor**: 환경 진단

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
