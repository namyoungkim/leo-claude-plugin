---
name: project-scaffold
description: "새 프로젝트 디렉토리에 표준 문서 템플릿과 Claude Code 설정을 생성. 트리거: /project-scaffold"
disable-model-invocation: true
argument-hint: "[type: infra|app]"
---

# /project-scaffold — 프로젝트 초기 구조 생성

새 프로젝트 디렉토리에 표준 문서 템플릿과 Claude Code 설정을 일괄 생성한다.

## 전제 조건

- 현재 디렉토리가 프로젝트 루트일 것
- git repo가 초기화되어 있을 것 (`git rev-parse --is-inside-work-tree`)

git repo가 없으면 `git init`을 실행할지 사용자에게 확인한다.

## 프로젝트 유형

### `app` — 코드 프로젝트 (기본값)

기존 `templates/project/` 디렉토리의 템플릿을 사용한다.

생성되는 파일 구조:

```
CLAUDE.md
docs/
├── ARCHITECTURE.md
├── CONVENTIONS.md
├── PATTERNS.md
└── MISTAKES.md
.claude/
└── settings.json
```

### `infra` — 인프라 프로젝트

정적 템플릿 없이, 사용자 인터뷰를 통해 동적으로 생성한다.

1. AskUserQuestion으로 프로젝트 정보 수집:
   - 프로젝트 목적 (한 줄)
   - 주요 서비스 목록
   - Layer 구분 (있다면)

2. 수집한 정보를 바탕으로 구조 생성:

```
CLAUDE.md                          ← 프로젝트 진입점 (수집 정보 반영)
docs/
├── ROADMAP.md                     ← 로드맵 (서비스/Layer 구조 반영)
├── PROGRESS.md                    ← 진행 상황 추적 테이블
├── DECISIONS.md                   ← 결정 기록 (빈 템플릿)
├── REVIEW_CHECKLIST.md            ← 검증 체크리스트
├── GITHUB_WORKFLOW.md             ← GitHub 운영 가이드
└── implementation/                ← Layer별 구현 상세
.claude/
├── settings.json                  ← 권한 + 훅
└── rules/
    └── infra-workflow.md          ← 워크플로우 규칙
```

## $ARGUMENTS가 없는 경우

사용자에게 프로젝트 유형을 AskUserQuestion으로 선택하게 한다.

## 실행 단계

### 1. 기존 파일 확인

프로젝트 디렉토리에 이미 CLAUDE.md나 docs/가 있는지 확인한다.
- 있으면: 덮어쓸지 건너뛸지 사용자에게 확인
- 없으면: 진행

### 2. 파일 생성

- `app`: 템플릿 파일들을 Read로 읽어서 Write로 생성. `[프로젝트명]` → 현재 디렉토리명으로 치환.
- `infra`: 인터뷰 결과를 바탕으로 각 파일 내용을 생성.

### 3. git 초기 파일 확인

- `.gitignore`가 없으면 기본 `.gitignore` 생성 (`.env`, `.env.*`, `secrets/` 포함)
- `.gitignore`가 있으면 `.env` 항목이 포함되어 있는지 확인, 없으면 추가 제안

### 4. 결과 리포트

```
┌─ Project Scaffold ─────────────────
│ Type:     {type}
│ Created:  {n} files
│ Skipped:  {n} files (already exist)
│
│ Next steps:
│  1. CLAUDE.md를 프로젝트에 맞게 수정
│  2. docs/ROADMAP.md에 로드맵 작성
│  3. /github-init으로 GitHub 설정
└────────────────────────────────────
```

## 규칙

- 기존 파일은 절대 자동으로 덮어쓰지 않는다
- 최소한의 구조만 제공 — 내용은 사용자가 채운다
- `.env` 파일은 생성하지 않는다 (보안)
