---
description: "Leo Plugin 초기 설정 및 환경 구성"
allowed-tools: Bash, Read, Edit, AskUserQuestion
---

# Setup Guide

Leo Claude Plugin 개발 환경을 설정합니다.

## 설정 항목

### 1. Python 환경 확인
- Python 버전 확인 (3.11+ 권장)
- uv 설치 여부 확인
- ruff 설치 여부 확인

### 2. 권장 도구 설치
```bash
# uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# ruff (linter + formatter)
uv tool install ruff
```

### 3. VS Code 설정
- Python extension
- Ruff extension
- GitLens extension

### 4. Git 설정 확인
- user.name, user.email 설정
- GPG signing (선택)

## 실행

각 항목을 순차적으로 확인하고 필요한 설치/설정을 진행합니다.
