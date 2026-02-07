---
name: checkup
description: "개발 환경 진단 및 문제 해결"
allowed-tools: Bash, Read
---

# Environment Checkup

개발 환경을 진단하고 문제를 식별합니다.

## 프로젝트 언어 감지

프로젝트 루트에서 다음 파일로 언어를 감지한다:

| 파일 | 언어 |
|------|------|
| `pyproject.toml` / `setup.py` | Python |
| `Cargo.toml` | Rust |
| `go.mod` | Go |
| `package.json` + `tsconfig.json` | TypeScript |
| `package.json` (tsconfig 없음) | JavaScript |

감지된 언어에 해당하는 항목만 진단한다. 감지 실패 시 전체 항목을 진단한다.

## 공통 진단 항목

### System
- [ ] OS version
- [ ] Shell (bash/zsh)
- [ ] PATH configuration

### Git
- [ ] Git version
- [ ] user.name, user.email 설정
- [ ] GPG signing (선택)

### Editor
- [ ] VS Code settings.json (있으면)

## 언어별 진단 항목

### Python (pyproject.toml 감지 시)
- [ ] Python version (3.11+ required)
- [ ] uv availability
- [ ] ruff installed (`ruff --version`)
- [ ] ty installed (`ty --version`)
- [ ] Virtual environment status

### Rust (Cargo.toml 감지 시)
- [ ] rustc version
- [ ] cargo version
- [ ] clippy installed (`cargo clippy --version`)
- [ ] rustfmt installed (`rustfmt --version`)

### Go (go.mod 감지 시)
- [ ] go version (1.21+ required)
- [ ] golangci-lint installed (`golangci-lint --version`)
- [ ] gofmt available

### TypeScript (package.json + tsconfig.json 감지 시)
- [ ] Node.js version (18+ required)
- [ ] pnpm / npm availability
- [ ] eslint installed
- [ ] prettier installed
- [ ] TypeScript compiler (`tsc --version`)

## Output Format

```
Environment Checkup Report
Language detected: Python

[PASS] Python 3.12.0
[PASS] uv 0.5.x
[WARN] ruff not found - run: uv tool install ruff
[FAIL] Git user.email not set - run: git config --global user.email "you@example.com"

Summary: 2 passed, 1 warning, 1 failed
```

## 진단 실행

환경을 스캔하고 결과를 보고합니다.
