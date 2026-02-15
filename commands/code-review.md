---
name: code-review
description: "현재 변경사항 빠른 인라인 코드 리뷰. 심층 리뷰는 @code-reviewer 에이전트 사용"
allowed-tools: Bash, Read, Grep, Glob
argument-hint: "[branch-or-file]"
---

# Quick Code Review

현재 변경사항을 빠르게 인라인 리뷰해줘.

## 리뷰 대상

인자가 주어지면 해당 대상을 리뷰한다:
- `$ARGUMENTS`가 파일 경로면 → 해당 파일만 리뷰
- `$ARGUMENTS`가 브랜치명이면 → 해당 브랜치와의 diff 리뷰
- 인자가 없으면 → `git diff`로 현재 변경사항 리뷰

## 컨텍스트 수집

```
현재 브랜치: !`git branch --show-current`
변경 파일 목록: !`git diff --staged --name-only 2>/dev/null; git diff --name-only 2>/dev/null`
```

## 리뷰 체크리스트

[review-checklist.md](../references/review-checklist.md) 참조.

빠른 리뷰이므로 diff에 보이는 변경사항만 집중한다. 전체 코드베이스 맥락이 필요한 심층 리뷰는 `@code-reviewer` 에이전트를 사용한다.
