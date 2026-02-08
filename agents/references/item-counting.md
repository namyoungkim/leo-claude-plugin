# 항목 수 계산 기준

MISTAKES.md / PATTERNS.md의 항목 수를 세는 공통 기준.

## 계산 방법

```bash
grep -cE '^(## |### \[)' <파일>
```

- `## ` (h2 헤더): 카테고리 없이 바로 항목이 시작하는 경우
- `### [` (h3 with date): 날짜 태그가 포함된 항목 헤더

## 임계값

| 파일 | soft cap | hard cap |
|------|----------|----------|
| MISTAKES.md | 15항목 (≈120줄) | 25항목 (≈200줄) |
| PATTERNS.md | 15항목 (≈150줄) | 25항목 (≈250줄) |

## 참조하는 곳

- `agents/reflector.md` — 항목 추가 전 크기 확인
- `commands/harvest.md` — 아카이브 시 항목 수 검증
