---
description: "프로젝트 간 범용 지식 수집. 🌍 universal 항목을 글로벌 설정으로 승격"
allowed-tools: Bash, Read, Grep, Glob, Edit, AskUserQuestion
---

# Harvest — 프로젝트 간 범용 지식 수집

여러 프로젝트의 docs/에서 🌍 universal로 태깅된 항목을 수집하고, 글로벌 설정 레포에 반영할 제안을 만들어줘.

## 전제 조건
- `~/.claude/projects.json`에 등록된 프로젝트 목록이 필요
- 등록 방법: 수동으로 경로 추가하거나 `/init-project`가 등록

## 수집 대상

등록된 각 프로젝트에서 다음 파일을 스캔:
1. `docs/PATTERNS.md` — scope: 🌍 universal 항목
2. `docs/MISTAKES.md` — scope: 🌍 universal 항목

## 수집 프로세스

### 1단계: 스캔
```
각 프로젝트 경로에 대해:
  1. docs/PATTERNS.md 읽기 → 🌍 universal 항목 추출
  2. docs/MISTAKES.md 읽기 → 🌍 universal 항목 추출
  3. 이미 harvested: true로 마킹된 항목은 건너뜀
```

### 2단계: 중복 제거
- 여러 프로젝트에서 동일하거나 유사한 항목이 발견되면 하나로 병합
- 가장 상세한 버전을 기준으로 통합
- 원본 프로젝트들을 출처로 기록

### 3단계: 분류
수집된 항목을 반영 대상별로 분류:

| 분류 | 반영 대상 | 예시 |
|------|----------|------|
| 📘 Skill 추가 | `skills/{언어}/SKILL.md` | 코드 패턴, 설정 가이드 |
| 📋 규칙 추가 | `CLAUDE.md` (글로벌) | NEVER/ALWAYS 규칙 |
| ⚙️ Hook 전환 | `settings.json` 템플릿 | 자동화 가능한 규칙 |
| 📄 템플릿 개선 | `project/docs/` 템플릿 | 문서 구조 개선 |
| 🗑️ 해당 없음 | 반영 불필요 | 재검토 후 project-only로 전환 |

### 4단계: 제안 출력
각 항목에 대해:
```
## [분류 이모지] 항목 제목
- **원본**: 프로젝트명, 발견일
- **현재 위치**: project-a/docs/PATTERNS.md
- **반영 대상**: skills/{언어}/SKILL.md
- **내용 요약**: (1-2줄)
- **구체적 변경**:
  (파일 경로와 추가/수정할 내용)
```

### 5단계: 승인 및 반영
- **사람의 승인 없이 어떤 파일도 수정하지 않음**
- 승인된 항목만 반영
- 반영 후 원본 프로젝트의 해당 항목에 `harvested: true` 마킹

## 마킹 형식

반영 완료 후 원본 항목에 추가되는 메타데이터:
```markdown
## DB 세션 관리 패턴
- **scope**: 🌍 universal
- **harvested**: true ← 이 줄이 추가됨
- **harvested_to**: skills/{언어}/SKILL.md ← 반영 위치
- **harvested_date**: 2026-02-15 ← 반영 일자
- **발견일**: 2026-02-10
...
```

## 규칙
- 사람의 승인 없이 파일을 수정하지 않음
- 수집 결과를 분류별로 정리하여 한눈에 파악 가능하게 출력
- 이미 글로벌에 유사 내용이 있으면 "병합 제안"으로 표시
- 등록된 프로젝트 경로가 접근 불가능하면 해당 프로젝트를 건너뛰고 알림
- harvested: true인 항목은 절대 중복 수집하지 않음

## 프로젝트 등록 안내
등록된 프로젝트가 없거나 `~/.claude/projects.json`이 없으면:
```
⚠️ 등록된 프로젝트가 없습니다.
~/.claude/projects.json에 프로젝트 경로를 등록하세요:

{
  "projects": [
    {"name": "my-project", "path": "/path/to/my-project"},
    {"name": "my-api", "path": "/path/to/my-api"}
  ]
}

또는 /init-project로 프로젝트를 초기화하면 자동 등록됩니다.
```
