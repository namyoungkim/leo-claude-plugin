# visor 위젯 레퍼런스

## 위젯 목록

| 위젯 | 식별자 | 설명 | 예시 |
|------|--------|------|------|
| 모델명 | `model` | 현재 사용 중인 모델 | `Opus` |
| 컨텍스트 | `context` | 컨텍스트 윈도우 사용률 + 프로그레스 바 | `Ctx: 42% ████░░░░░░` |
| 캐시 히트율 | `cache_hit` | 캐시에서 읽은 토큰 비율 | `Cache: 80%` |
| API 지연시간 | `api_latency` | 총 API 호출 시간 | `API: 2.5s` |
| 비용 | `cost` | 세션 총 비용 | `$0.15` |
| 코드 변경 | `code_changes` | 추가/삭제된 라인 수 | `+25/-10` |
| Git | `git` | 브랜치, 상태 | `main ↑1` |
| 번 레이트 | `burn_rate` | 분당 비용 소모율 | `64.0¢/min` |
| Compact 예측 | `compact_eta` | 80% context 도달 예측 | `~18m` |
| Context 스파크라인 | `context_spark` | 히스토리 기반 미니 그래프 | `▂▃▄▅▆` |
| 도구 상태 | `tools` | 최근 도구 호출 상태 | `✓Read ✓Write ◐Bash` |
| 에이전트 상태 | `agents` | 서브 에이전트 상태 | `✓Plan ◐Explore` |
| 일별 비용 | `daily_cost` | 오늘 누적 비용 | `$2.34 today` |
| 주별 비용 | `weekly_cost` | 이번 주 누적 비용 | `$15.67 week` |
| 블록 비용 | `block_cost` | 5시간 블록 비용 | `$0.45 block` |
| 5시간 제한 | `block_limit` | 5시간 블록 사용률 | `5h: 42%` |
| 7일 제한 | `week_limit` | 주간 사용률 | `7d: 69%` |

## 색상 임계값

### Cache Hit Rate
```
rate = cache_read_tokens / (cache_read_tokens + input_tokens) × 100
```
| 범위 | 색상 | 의미 |
|------|------|------|
| ≥ 80% | 초록색 | 효율적 |
| 50-80% | 노란색 | 보통 |
| < 50% | 빨간색 | 비효율적 |

### API Latency
| 범위 | 색상 |
|------|------|
| < 2초 | 초록색 |
| 2-5초 | 노란색 |
| > 5초 | 빨간색 |

### Code Changes
| 타입 | 색상 |
|------|------|
| 추가 (+) | 초록색 |
| 삭제 (-) | 빨간색 |

## Extra 옵션

| 위젯 | 옵션 | 기본값 | 설명 |
|------|------|--------|------|
| `context` | `show_label` | `true` | "Ctx:" 접두사 표시 |
| `context` | `show_bar` | `true` | 프로그레스 바 표시 |
| `context` | `bar_width` | `10` | 프로그레스 바 너비 |
| `cache_hit` | `show_label` | `true` | "Cache:" 접두사 표시 |
| `cost` | `show_label` | `false` | "Cost:" 접두사 표시 |
| `block_limit` | `show_label` | `true` | "5h:" 접두사 표시 |
| `block_limit` | `show_remaining` | `true` | 남은 시간 표시 |
| `block_limit` | `show_bar` | `false` | 프로그레스 바 표시 |
| `block_limit` | `bar_width` | `10` | 프로그레스 바 너비 |

## 테마

| 테마 | 설명 |
|------|------|
| `default` | 기본 ASCII 구분자 |
| `powerline` | Powerline 글리프 (, ) |
| `gruvbox` | Gruvbox 색상 팔레트 |
| `nord` | Nord 색상 팔레트 |
| `gruvbox-powerline` | Gruvbox + Powerline |
| `nord-powerline` | Nord + Powerline |

### 커스텀 테마

```toml
[theme]
name = "gruvbox"       # 베이스 프리셋
powerline = true       # Powerline 스타일

[theme.colors]
warning = "#ff00ff"    # Hex 색상
critical = "red"       # Named 색상
backgrounds = ["#111111", "#222222", "#333333"]

[theme.separators]
left = " :: "
right = " :: "
```

**색상 형식:**
- Hex: `#RGB`, `#RRGGBB`, `#RRGGBBAA`
- Named: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, `gray`
- Bright: `brightred`, `brightgreen`, `brightyellow`, `brightblue`, `brightmagenta`, `brightcyan`, `brightwhite`

## TUI 키바인딩

| 키 | 동작 |
|----|------|
| `j/k` | 커서 이동 |
| `a` | 위젯 추가 |
| `d` | 위젯 삭제 |
| `e` | 옵션 편집 |
| `J/K` | 위젯 순서 변경 |
| `L` | 레이아웃 변경 (single/split) |
| `t` | 테마 변경 |
| `s` | 저장 |
| `q` | 종료 |
