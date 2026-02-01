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
└── commands/
```

**설치**: `/plugin add <url>`

**특징**:
- 설치 시 해당 플러그인의 모든 skills/agents/commands 활성화
- 간단한 구조, 관리 용이

**적합한 경우**:
- 개인용 플러그인
- 특정 프로젝트/팀 전용
- 스킬 수 15개 미만

### Marketplace (마켓플레이스)

```
my-marketplace/
├── .claude-plugin/
│   └── marketplace.json  ← 플러그인 목록
```

```json
{
  "name": "my-plugins-marketplace",
  "description": "Plugin collection",
  "plugins": [
    {"name": "python-tools", "url": "https://github.com/user/python-tools"},
    {"name": "git-helpers", "url": "https://github.com/user/git-helpers"}
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
1. 스킬 수가 적음 (8개)
2. 개인용 도구 모음
3. 관리 단순화

### 도메인 분류

현재 스킬들은 3개 도메인으로 분류됨:

| 도메인 | Skills |
|--------|--------|
| Python 개발 | python-project, coding-problem-solver |
| Git 워크플로우 | git-workflow, git-master, git-worktree |
| 인프라/기획 | opensearch-client, opensearch-server, product-planning |

---

## 마켓플레이스 전환 시점

다음 상황에서 분리 고려:

### 전환 기준

- [ ] 팀/조직에 배포하고 팀별로 다른 스킬 조합 필요
- [ ] 특정 스킬만 오픈소스로 공개
- [ ] 스킬이 20개 이상으로 증가
- [ ] 스킬별 버전 관리 필요

### 전환 시 구조

```
leo-plugins-marketplace/          ← 마켓플레이스 (카탈로그)
├── .claude-plugin/
│   └── marketplace.json
│
leo-python-plugin/                ← 백엔드팀용
├── skills/
│   ├── python-project/
│   └── coding-problem-solver/
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
| 개인용, 스킬 < 15개 | 단일 플러그인 (현재) |
| 팀 배포, 권한 분리 | 마켓플레이스 + 도메인별 플러그인 |
| 커뮤니티 배포 | 마켓플레이스 (선택적 설치) |
