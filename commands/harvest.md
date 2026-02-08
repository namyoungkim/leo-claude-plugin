---
name: harvest
description: "프로젝트 간 범용 지식 수집. 🌍 universal 항목을 글로벌 설정으로 승격"
allowed-tools: Bash, Read, Grep, Glob, Edit, AskUserQuestion
disable-model-invocation: true
---

# Harvest — 프로젝트 간 범용 지식 수집

여러 프로젝트의 docs/에서 🌍 universal로 태깅된 항목을 수집하고, 이 플러그인에 반영할 제안을 만들어줘.

## 플러그인 경로

[플러그인 경로 확인](references/plugin-path.md) 참조. 아래의 모든 경로는 PLUGIN_ROOT 기준이다.

## 전제 조건
- 프로젝트 목록 파일이 필요. 다음 순서로 탐색:
  1. `$CLAUDE_CONFIG_DIR/projects.json` (환경변수 설정 시)
  2. `~/.claude/projects.json` (기본 경로)
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
| 📘 Skill 추가 | `PLUGIN_ROOT/skills/{언어}/SKILL.md` | 코드 패턴, 설정 가이드 |
| 📋 규칙 추가 | `PLUGIN_ROOT/CLAUDE.md` | NEVER/ALWAYS 규칙 |
| ⚙️ Hook 전환 | `PLUGIN_ROOT/templates/project/settings.json` | 자동화 가능한 규칙 |
| 📄 템플릿 개선 | `PLUGIN_ROOT/templates/project/docs/` | 문서 구조 개선 |
| 🗑️ 해당 없음 | 반영 불필요 | 재검토 후 project-only로 전환 |

### 4단계: 제안 출력
각 항목에 대해:
```
## [분류 이모지] 항목 제목
- **원본**: 프로젝트명, 발견일
- **현재 위치**: project-a/docs/PATTERNS.md
- **반영 대상**: PLUGIN_ROOT/skills/{언어}/SKILL.md
- **내용 요약**: (1-2줄)
- **구체적 변경**:
  (파일 경로와 추가/수정할 내용)
```

### 5단계: 승인 및 반영
- **사람의 승인 없이 어떤 파일도 수정하지 않음**
- 승인된 항목만 반영
- 반영 후 원본 프로젝트의 해당 항목에 `harvested: true` 마킹

### 6단계: 아카이브 (harvested 항목 정리)

반영 완료 후 원본 파일에서 `harvested: true` 항목을 아카이브로 이동:

1. `docs/archive/` 디렉토리가 없으면 생성
2. 현재 분기 기준 아카이브 파일에 append:
   - 분기 계산: 1-3월=Q1, 4-6월=Q2, 7-9월=Q3, 10-12월=Q4
   - `docs/archive/PATTERNS-YYYY-QN.md`
   - `docs/archive/MISTAKES-YYYY-QN.md`
3. 원본 파일에서 해당 항목 제거
   - 항목 수 계산: [항목 수 계산 기준](../agents/references/item-counting.md) 참조
4. 원본 파일의 `# 제목` 헤더와 빈 항목 구조는 유지

```
예시: 2026년 1분기 harvest 실행 후
docs/
├── MISTAKES.md              ← harvested 항목 제거됨 (활성 항목만)
├── PATTERNS.md              ← harvested 항목 제거됨 (활성 항목만)
└── archive/
    ├── MISTAKES-2026-Q1.md  ← 아카이브된 항목 (출처·날짜 보존)
    └── PATTERNS-2026-Q1.md
```

아카이브 파일 헤더 형식:
```markdown
# Archived Patterns — 2026 Q1
> Harvested on YYYY-MM-DD from {프로젝트명}

(원본 항목 그대로 복사)
```

**아카이브도 사람의 승인 후에만 실행한다.**

## 마킹 형식

반영 완료 후 원본 항목에 추가되는 메타데이터:
```markdown
## DB 세션 관리 패턴
- **scope**: 🌍 universal
- **harvested**: true ← 이 줄이 추가됨
- **harvested_to**: PLUGIN_ROOT/skills/{언어}/SKILL.md ← 반영 위치
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
등록된 프로젝트가 없거나 projects.json이 없으면:
```
⚠️ 등록된 프로젝트가 없습니다.
${CLAUDE_CONFIG_DIR:-~/.claude}/projects.json에 프로젝트 경로를 등록하세요:

{
  "projects": [
    {"name": "my-project", "path": "/path/to/my-project"},
    {"name": "my-api", "path": "/path/to/my-api"}
  ]
}

또는 /init-project로 프로젝트를 초기화하면 자동 등록됩니다.
```
