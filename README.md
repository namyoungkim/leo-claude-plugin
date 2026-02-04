# Leo's Claude Plugin

Claude Code 플러그인. Skills, Agents, Commands, Hooks 포함.

## 설치

```bash
# 방법 1: 단일 플러그인으로 설치
/plugin add https://github.com/namyoungkim/leo-claude-plugin

# 방법 2: 마켓플레이스로 설치
/plugin marketplace add https://github.com/namyoungkim/leo-claude-plugin
```

> **Plugin vs Marketplace**
> - **Plugin**: 1개 저장소 = 1개 플러그인 (직접 설치)
> - **Marketplace**: 플러그인 카탈로그에서 선택 설치

## 구성 요소

### Skills (8개)

| Skill | 설명 |
|-------|------|
| coding-problem-solver | 코딩 인터뷰 문제 풀이 정리 |
| git-master | Atomic commits, rebase/squash, history search |
| git-workflow | GitHub Flow 브랜치 전략, 커밋 컨벤션 |
| git-worktree | Git worktree 병렬 개발 가이드 |
| opensearch-client | OpenSearch Python 클라이언트 |
| opensearch-server | Docker 기반 OpenSearch 서버 관리 |
| product-planning | 인터뷰 기반 제품/프로젝트 기획 |
| python-project | Python 프로젝트 세팅 (uv + ruff + ty) |

### Agents (2개)

| Agent | 설명 |
|-------|------|
| code-reviewer | 코드 리뷰 전문가 (읽기 전용) |
| refactor-assistant | 리팩토링 도우미 |

### Commands (2개)

| Command | 설명 |
|---------|------|
| /setup | 개발 환경 초기 설정 |
| /doctor | 환경 진단 및 문제 해결 |

### Hooks

- Python 파일 편집 시 자동 포맷팅 (ruff)
- Git commit 전 린트 체크

## 사용 예시

```bash
# 스킬 호출
/leo-claude-plugin:python-project
/leo-claude-plugin:git-workflow

# 명령어 실행
/leo-claude-plugin:setup
/leo-claude-plugin:doctor
```

## 구조

```
leo-claude-plugin/
├── .claude-plugin/
│   ├── plugin.json          # 플러그인 메타데이터
│   └── marketplace.json     # 마켓플레이스 카탈로그
├── skills/                   # 스킬 (8개)
│   ├── coding-problem-solver/
│   ├── git-master/
│   ├── git-workflow/
│   ├── git-worktree/
│   ├── opensearch-client/
│   ├── opensearch-server/
│   ├── product-planning/
│   └── python-project/
├── agents/                   # 에이전트 (2개)
│   ├── code-reviewer.md
│   └── refactor-assistant.md
├── commands/                 # 슬래시 명령어 (2개)
│   ├── setup.md
│   └── doctor.md
├── hooks/                    # 훅 설정
│   └── hooks.json
├── docs/                     # 설계 문서
│   └── architecture.md       # 플러그인 구조, 마켓플레이스 패턴
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
