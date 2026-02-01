---
description: "개발 환경 진단 및 문제 해결"
allowed-tools: Bash, Read
---

# Environment Doctor

개발 환경을 진단하고 문제를 식별합니다.

## 진단 항목

### System
- [ ] OS version
- [ ] Shell (bash/zsh)
- [ ] PATH configuration

### Python
- [ ] Python version (3.11+ required)
- [ ] pip/uv availability
- [ ] Virtual environment status

### Development Tools
- [ ] Git version and configuration
- [ ] Node.js/npm (if needed)
- [ ] Docker (if needed)

### Linting/Formatting
- [ ] ruff installed
- [ ] ty (type checker) installed
- [ ] Pre-commit hooks configured

### Editor
- [ ] VS Code settings.json
- [ ] Recommended extensions

## Output Format

```
Development Environment Diagnostic Report

[PASS] Python 3.12.0
[PASS] uv 0.5.x
[WARN] ruff not found - run: uv tool install ruff
[FAIL] Git user.email not set - run: git config --global user.email "you@example.com"

Summary: 2 passed, 1 warning, 1 failed
```

## 진단 실행

환경을 스캔하고 결과를 보고합니다.
