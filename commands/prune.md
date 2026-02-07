---
name: prune
description: "CLAUDE.md 정리. 50줄 이내 유지, 세부 내용을 docs/hooks/skills로 이동"
allowed-tools: Bash, Read, Edit, Grep, Glob, AskUserQuestion
disable-model-invocation: true
---

# CLAUDE.md Pruning

CLAUDE.md를 분석하고 가지치기해줘.

## 가지치기 기준

### 1. 제거 대상
- Claude가 지시 없이도 이미 올바르게 수행하는 규칙
- 더 이상 프로젝트에 해당하지 않는 오래된 규칙
- 중복된 규칙 (같은 내용을 다른 표현으로 반복)

### 2. Hook으로 이관 대상
- "반드시 ~해라" 형태의 강제 규칙 중 자동 검증 가능한 것
- 파일 수정 시 항상 해야 하는 체크리스트

### 3. Skill로 승격 대상
- 3줄 이상의 상세한 가이드라인
- 특정 도메인 지식 (API 패턴, DB 스키마 등)
- 코드 예시가 포함된 설명

### 4. 별도 문서로 분리 대상
- 5줄 이상의 상세 설명 → `docs/` 하위 문서로 이동
- 과거 실수 기록 → `docs/MISTAKES.md`
- 코드 패턴 모음 → `docs/PATTERNS.md`
- 아키텍처 결정 → `docs/ARCHITECTURE.md`

## 목표
- CLAUDE.md는 **50줄 이내** 유지
- 각 규칙은 1-2줄로 명확하게
- NEVER/ALWAYS로 시작하는 절대 규칙 위주
- 상세 내용은 `→ docs/XXX.md 참조` 형태로 링크

## 프로세스
1. 현재 CLAUDE.md의 모든 규칙을 나열
2. 각 규칙을 위 4가지 기준에 따라 분류 (표로 제시)
3. 가지치기 후의 CLAUDE.md 초안 제시
4. 이관/승격/분리 대상의 구체적 이동 계획 제시
5. **사람의 승인 후에만 실행**

## 주의사항
- 절대 규칙(NEVER/ALWAYS)은 함부로 제거하지 말 것
- 제거 전에 해당 규칙이 정말 불필요한지 근거를 설명할 것
- Hook 이관 시 settings.json의 구체적 설정도 함께 제시할 것
