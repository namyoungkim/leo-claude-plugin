---
name: setup
description: "Leo Plugin 초기 설정 및 환경 구성"
allowed-tools: Bash, Read, Edit, AskUserQuestion
---

# Setup Guide

Leo Claude Plugin 개발 환경을 설정합니다.

## 프로젝트 언어 감지

프로젝트 루트에서 다음 파일로 언어를 자동 감지한다:

| 파일 | 언어 |
|------|------|
| `pyproject.toml` / `setup.py` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `package.json` + `tsconfig.json` | TypeScript |

감지 실패 시 사용자에게 AskUserQuestion으로 언어를 묻는다.

## 공통 설정

### 1. Git 설정 확인
- user.name, user.email 설정
- GPG signing (선택)

### 2. VS Code 공통 확장
- GitLens extension

## 언어별 설정

### Python

**도구 설치:**
```bash
# uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# ruff (linter + formatter)
uv tool install ruff

# ty (type checker)
uv tool install ty
```

**VS Code 확장:**
- Python extension
- Ruff extension

### Rust

**도구 설치:**
```bash
# rustup (Rust toolchain)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# clippy, rustfmt (rustup 기본 포함 확인)
rustup component add clippy rustfmt
```

**VS Code 확장:**
- rust-analyzer extension

### Go

**도구 설치:**
```bash
# Go는 공식 사이트에서 설치: https://go.dev/dl/

# golangci-lint
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

**VS Code 확장:**
- Go extension (by Google)

### TypeScript

**도구 설치:**
```bash
# pnpm (package manager)
npm install -g pnpm

# eslint + prettier (프로젝트 로컬)
pnpm add -D eslint prettier typescript
```

**VS Code 확장:**
- ESLint extension
- Prettier extension

## 실행

각 항목을 순차적으로 확인하고 필요한 설치/설정을 진행합니다.
설치 전 사용자에게 확인을 요청합니다.
