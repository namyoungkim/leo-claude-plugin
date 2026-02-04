---
name: visor
description: Claude Code efficiency dashboard statusline installation and configuration. Displays cache hit rate, API latency, burn rate. Triggers on "install visor", "setup statusline", "efficiency dashboard", "visor setup".
allowed-tools: Bash, Read, Edit
---

# visor

Claude Code efficiency dashboard statusline.

```
Opus | Ctx: 42% ████░░░░░░ | Cache: 80% | API: 2.5s | $0.15 | main ↑1
```

## Quick Start

```bash
# 1. Install (see Installation section for options)
VERSION=0.9.0
curl -sL "https://github.com/namyoungkim/visor/releases/download/v${VERSION}/visor_${VERSION}_darwin_arm64.tar.gz" | tar xz
sudo mv visor /usr/local/bin/

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

## Installation

### Binary Download (Recommended)

No Go installation required.

```bash
# 1. Set version (check latest at https://github.com/namyoungkim/visor/releases)
VERSION=0.9.0

# 2. Download binary for your platform
curl -sL "https://github.com/namyoungkim/visor/releases/download/v${VERSION}/visor_${VERSION}_darwin_arm64.tar.gz" | tar xz   # macOS Apple Silicon
curl -sL "https://github.com/namyoungkim/visor/releases/download/v${VERSION}/visor_${VERSION}_darwin_amd64.tar.gz" | tar xz   # macOS Intel
curl -sL "https://github.com/namyoungkim/visor/releases/download/v${VERSION}/visor_${VERSION}_linux_amd64.tar.gz" | tar xz    # Linux x64
curl -sL "https://github.com/namyoungkim/visor/releases/download/v${VERSION}/visor_${VERSION}_linux_arm64.tar.gz" | tar xz    # Linux ARM64

# 3. Install to PATH
sudo mv visor /usr/local/bin/

# Without sudo:
mkdir -p ~/.local/bin && mv visor ~/.local/bin/
# Add to PATH if needed: export PATH="$HOME/.local/bin:$PATH"
```

### Go install

If Go 1.22+ is installed:

```bash
go install github.com/namyoungkim/visor@latest
```

### Build from source

```bash
git clone https://github.com/namyoungkim/visor.git
cd visor
go build -o visor ./cmd/visor
sudo mv visor /usr/local/bin/
```

## Presets

| Preset | Description | Widgets |
|--------|-------------|---------|
| `minimal` | Essential info only | 4 |
| `default` | Balanced defaults | 6 |
| `efficiency` | Cost optimization focus | 6 |
| `developer` | Tool/agent monitoring | 6 |
| `pro` | Claude Pro usage limits | 6 |
| `full` | All widgets, multiline | 18 |

```bash
visor --init              # default preset
visor --init minimal      # specific preset
visor --init help         # list presets
```

## Claude Code Integration

### Method 1: settings.json (Recommended)

```bash
# Edit ~/.claude/settings.json
{
  "statusline": {
    "command": "visor"
  }
}
```

### Method 2: Environment variable

```bash
export CLAUDE_STATUSLINE_COMMAND="visor"
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `visor --version` | Print version |
| `visor --init` | Generate config (default) |
| `visor --init <preset>` | Generate with specific preset |
| `visor --init help` | List presets |
| `visor --setup` | Claude Code integration guide |
| `visor --check` | Validate config |
| `visor --tui` | Interactive config editor |
| `visor --debug` | Print debug info |

## Verification

```bash
# 1. Check installation
which visor
visor --version

# 2. Check config
visor --check

# 3. Manual test
echo '{"model":{"display_name":"Opus"},"context_window":{"used_percentage":42.5}}' | visor

# 4. Restart Claude Code and verify statusline
```

## Troubleshooting

### "command not found"

```bash
# Check if visor is in PATH
which visor

# If installed to ~/.local/bin, add to PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
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

- [ ] Download and install visor binary
- [ ] Run `visor --init`
- [ ] Add statusline config to `~/.claude/settings.json`
- [ ] Restart Claude Code
- [ ] Verify statusline displays

## References

- Widget details: `references/widgets.md`
- Default config: `assets/config-default.toml`
- GitHub: https://github.com/namyoungkim/visor
