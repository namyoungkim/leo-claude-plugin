# 컴포넌트 목록

## Available Skills

**언어별 표준** — `user-invocable: false`
- **go-standards**: Go 코딩 표준 (go mod + golangci-lint + gofmt)
- **python-standards**: Python 코딩 표준 (uv + ruff + ty + pytest)
- **rust-standards**: Rust 코딩 표준 (cargo + clippy + rustfmt)
- **typescript-standards**: TypeScript 코딩 표준 (pnpm + eslint + prettier + vitest)

**Git 워크플로우**
- **git-master**: 커밋 아키텍트 + 히스토리 전문가 (커밋/rebase/blame)
- **git-workflow**: GitHub Flow 브랜치 전략 + PR 워크플로우
- **git-worktree**: Git worktree 병렬 개발

**인프라/도메인** — `disable-model-invocation: true`
- **opensearch-client**: OpenSearch Python 클라이언트 (텍스트/벡터/하이브리드 검색)
- **opensearch-server**: Docker 기반 OpenSearch 서버 (Nori 한국어 분석기)
- **langgraph**: LangGraph 지식 베이스 검색 (`argument-hint: [질문]`)
- **python**: Python 지식 베이스 검색 (`argument-hint: [질문]`)
- **unix**: Unix 지식 베이스 검색 (`argument-hint: [질문]`)
- **openclaw**: OpenClaw 지식 베이스 검색 (`argument-hint: [질문]`)
- **claude-code**: Claude Code 지식 베이스 검색 (`argument-hint: [질문]`)

**플러그인/메타** — `user-invocable: false`
- **claude-code-standards**: Claude Code 플러그인 개발 표준 (공식 문서 기반)

**기획/도구** — `argument-hint`
- **product-planning**: 인터뷰 기반 제품/프로젝트 기획 (`argument-hint: [프로젝트명]`)
- **coding-problem-solver**: 코딩 인터뷰 문제 풀이 (`argument-hint: [문제 URL 또는 이름]`)

## Available Agents

- **code-reviewer**: 코드 리뷰 전문가 (git diff 분석)
- **refactor-assistant**: 리팩토링 도우미
- **reflector**: 세션 회고 및 자기 개선
- **langgraph-master**: LangGraph 지식 베이스 전문가 (kb CLI 기반 검색)
- **python-master**: Python 지식 베이스 전문가 (kb CLI 기반 검색)
- **unix-master**: Unix 지식 베이스 전문가 (kb CLI 기반 검색)
- **openclaw-master**: OpenClaw 지식 베이스 전문가 (kb CLI 기반 검색)
- **claude-code-master**: Claude Code 지식 베이스 전문가 (kb CLI 기반 검색)

## Available Commands

- **/setup**: 개발 환경 초기 설정
- **/checkup**: 환경 진단
- **/reflect**: 세션 회고 + 개선 제안
- **/harvest**: 프로젝트 간 지식 수집
- **/prune**: CLAUDE.md 정리
- **/code-review**: 빠른 코드 리뷰
- **/init-project**: 프로젝트 템플릿 배포
