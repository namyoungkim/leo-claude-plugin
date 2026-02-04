# visor Widget Reference

## Widget List

| Widget | Identifier | Description | Example |
|--------|------------|-------------|---------|
| Model | `model` | Current model in use | `Opus` |
| Context | `context` | Context window usage + progress bar | `Ctx: 42% ████░░░░░░` |
| Cache Hit Rate | `cache_hit` | Token ratio read from cache | `Cache: 80%` |
| API Latency | `api_latency` | Total API call time | `API: 2.5s` |
| Cost | `cost` | Session total cost | `$0.15` |
| Code Changes | `code_changes` | Lines added/deleted | `+25/-10` |
| Git | `git` | Branch and status | `main ↑1` |
| Burn Rate | `burn_rate` | Cost per minute | `64.0¢/min` |
| Compact ETA | `compact_eta` | Time to 80% context | `~18m` |
| Context Sparkline | `context_spark` | History-based mini graph | `▂▃▄▅▆` |
| Tools Status | `tools` | Recent tool call status | `✓Read ✓Write ◐Bash` |
| Agents Status | `agents` | Sub-agent status | `✓Plan ◐Explore` |
| Daily Cost | `daily_cost` | Today's accumulated cost | `$2.34 today` |
| Weekly Cost | `weekly_cost` | This week's accumulated cost | `$15.67 week` |
| Block Cost | `block_cost` | 5-hour block cost | `$0.45 block` |
| 5-Hour Limit | `block_limit` | 5-hour block usage | `5h: 42%` |
| 7-Day Limit | `week_limit` | Weekly usage | `7d: 69%` |

## Color Thresholds

### Cache Hit Rate
```
rate = cache_read_tokens / (cache_read_tokens + input_tokens) × 100
```
| Range | Color | Meaning |
|-------|-------|---------|
| ≥ 80% | Green | Efficient |
| 50-80% | Yellow | Normal |
| < 50% | Red | Inefficient |

### API Latency
| Range | Color |
|-------|-------|
| < 2s | Green |
| 2-5s | Yellow |
| > 5s | Red |

### Code Changes
| Type | Color |
|------|-------|
| Addition (+) | Green |
| Deletion (-) | Red |

## Extra Options

| Widget | Option | Default | Description |
|--------|--------|---------|-------------|
| `context` | `show_label` | `true` | Show "Ctx:" prefix |
| `context` | `show_bar` | `true` | Show progress bar |
| `context` | `bar_width` | `10` | Progress bar width |
| `cache_hit` | `show_label` | `true` | Show "Cache:" prefix |
| `cost` | `show_label` | `false` | Show "Cost:" prefix |
| `block_limit` | `show_label` | `true` | Show "5h:" prefix |
| `block_limit` | `show_remaining` | `true` | Show remaining time |
| `block_limit` | `show_bar` | `false` | Show progress bar |
| `block_limit` | `bar_width` | `10` | Progress bar width |

## Themes

| Theme | Description |
|-------|-------------|
| `default` | Default ASCII separators |
| `powerline` | Powerline glyphs (, ) |
| `gruvbox` | Gruvbox color palette |
| `nord` | Nord color palette |
| `gruvbox-powerline` | Gruvbox + Powerline |
| `nord-powerline` | Nord + Powerline |

### Custom Theme

```toml
[theme]
name = "gruvbox"       # Base preset
powerline = true       # Powerline style

[theme.colors]
warning = "#ff00ff"    # Hex color
critical = "red"       # Named color
backgrounds = ["#111111", "#222222", "#333333"]

[theme.separators]
left = " :: "
right = " :: "
```

**Color formats:**
- Hex: `#RGB`, `#RRGGBB`, `#RRGGBBAA`
- Named: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, `gray`
- Bright: `brightred`, `brightgreen`, `brightyellow`, `brightblue`, `brightmagenta`, `brightcyan`, `brightwhite`

## TUI Keybindings

| Key | Action |
|-----|--------|
| `j/k` | Move cursor |
| `a` | Add widget |
| `d` | Delete widget |
| `e` | Edit options |
| `J/K` | Reorder widgets |
| `L` | Change layout (single/split) |
| `t` | Change theme |
| `s` | Save |
| `q` | Quit |
