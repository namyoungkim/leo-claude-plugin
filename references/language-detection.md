# 프로젝트 언어 감지

프로젝트 루트에서 다음 파일 존재 여부로 언어를 자동 감지한다.

## 감지 규칙

| 감지 파일 | 언어 | 주요 도구 |
|-----------|------|-----------|
| `pyproject.toml` / `setup.py` | Python | uv, ruff, ty, pytest |
| `Cargo.toml` | Rust | cargo, clippy, rustfmt |
| `go.mod` | Go | go, golangci-lint, gofmt |
| `package.json` + `tsconfig.json` | TypeScript | pnpm, eslint, prettier, vitest |
| `package.json` (tsconfig 없음) | JavaScript | npm, eslint, prettier |

## 다중 언어 프로젝트

여러 감지 파일이 동시에 존재하면 모든 해당 언어를 대상으로 포함한다.

## 감지 실패 시

- `/setup`: 사용자에게 AskUserQuestion으로 언어를 묻는다.
- `/checkup`: 전체 언어의 도구를 모두 진단한다.
