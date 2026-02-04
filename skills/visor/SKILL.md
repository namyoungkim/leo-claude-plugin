---
name: visor
description: Claude Code 효율성 대시보드 statusline 설치 및 설정. 캐시 히트율, API 지연시간, 번레이트 표시. Triggers on "visor 설치", "statusline 설정", "효율성 대시보드".
allowed-tools: Bash, Read, Edit
---

# visor

Claude Code 효율성 대시보드 statusline.

```
Opus | Ctx: 42% ████░░░░░░ | Cache: 80% | API: 2.5s | $0.15 | main ↑1
```

## Quick Start

```bash
# 1. Install
go install github.com/namyoungkim/visor@latest

# 2. Generate config
visor --init

# 3. Integrate with Claude Code
# Edit ~/.claude/settings.json
{
  "statusline": { "command": "visor" }
}

# 4. Verify
echo '{"model":{"display_name":"Opus"}}' | visor
```

## Prerequisites

```bash
# Check Go version (1.22+)
go version

# Check git (for git widget)
git --version
```

## Installation

### Go install (권장)

```bash
go install github.com/namyoungkim/visor@latest
```

### Build from source

```bash
git clone https://github.com/namyoungkim/visor.git
cd visor
go build -o visor ./cmd/visor
# Move to PATH
sudo mv visor /usr/local/bin/
```

## Presets

| 프리셋 | 설명 | 위젯 |
|--------|------|------|
| `minimal` | 필수 정보만 (4개) | model, context, cost, git |
| `default` | 균형 잡힌 기본값 (6개) | model, context, cache_hit, api_latency, cost, git |
| `efficiency` | 비용 최적화 중심 (6개) | model, context, burn_rate, cache_hit, compact_eta, cost |
| `developer` | 도구/에이전트 모니터링 (6개) | model, context, tools, agents, code_changes, git |
| `pro` | Claude Pro 사용량 제한 (6개) | model, context, block_limit, week_limit, daily_cost, cost |
| `full` | 모든 위젯, 멀티라인 (18개) | 카테고리별 5개 라인 |

```bash
visor --init              # default 프리셋
visor --init minimal      # 특정 프리셋
visor --init help         # 프리셋 목록
```

## Claude Code Integration

### 방법 1: settings.json (권장)

```bash
# ~/.claude/settings.json 편집
{
  "statusline": {
    "command": "visor"
  }
}
```

### 방법 2: 환경변수

```bash
export CLAUDE_STATUSLINE_COMMAND="visor"
```

## CLI Commands

| 명령 | 설명 |
|------|------|
| `visor --version` | 버전 출력 |
| `visor --init` | 설정 파일 생성 (default) |
| `visor --init <preset>` | 특정 프리셋으로 생성 |
| `visor --init help` | 프리셋 목록 |
| `visor --setup` | Claude Code 연동 가이드 |
| `visor --check` | 설정 유효성 검사 |
| `visor --tui` | 인터랙티브 설정 편집기 |
| `visor --debug` | 디버그 정보 출력 |

## Verification

```bash
# 1. Check installation
which visor
visor --version

# 2. Check config
visor --check

# 3. Manual test
echo '{"model":{"display_name":"Opus"},"context_window":{"used_percentage":42.5}}' | visor

# 4. Restart Claude Code
# 새 세션에서 statusline 확인
```

## Troubleshooting

### "command not found"

```bash
# Check Go bin in PATH
echo $PATH | tr ':' '\n' | grep go

# Add to shell config
echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Config not loading

```bash
# Check config location
ls -la ~/.config/visor/config.toml

# Validate config
visor --check

# Regenerate config
visor --init
```

### No output

```bash
# Debug mode
echo '{"model":{"display_name":"Opus"}}' | visor --debug
```

## Workflow Checklist

- [ ] Go 1.22+ 설치 확인
- [ ] `go install github.com/namyoungkim/visor@latest`
- [ ] `visor --init` 실행
- [ ] `~/.claude/settings.json`에 statusline 설정 추가
- [ ] Claude Code 재시작
- [ ] statusline 표시 확인

## References

- 위젯 상세: `references/widgets.md`
- 기본 설정: `assets/config-default.toml`
- GitHub: https://github.com/namyoungkim/visor
