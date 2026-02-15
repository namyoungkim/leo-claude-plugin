# Hooks Reference

Claude Code 훅 시스템 상세 스펙.

## Event Types (14개)

### SessionStart

세션 시작 또는 재개 시 발생.

- **차단**: 불가
- **Matcher**: `startup`, `resume`, `clear`, `compact`
- **입력**: `source`, `model`, (옵션) `agent_type`
- **특수**: `additionalContext` 필드로 Claude에 컨텍스트 추가 가능
- **환경 파일**: `CLAUDE_ENV_FILE`로 후속 Bash 명령에 환경변수 전달

### UserPromptSubmit

사용자가 프롬프트를 제출한 후, 처리 전에 발생.

- **차단**: 가능
- **Matcher**: 없음 (항상 발생)
- **차단 방식**: 최상위 `decision: "block"` + `reason`

### PreToolUse

도구 호출 실행 전에 발생.

- **차단**: 가능
- **Matcher**: 도구명 (정규식). 예: `Bash`, `Edit|Write`, `mcp__.*`
- **차단 방식**: `hookSpecificOutput`의 `permissionDecision`

**hookSpecificOutput 필드:**

| 필드 | 설명 |
|------|------|
| `permissionDecision` | `"allow"` (권한 우회), `"deny"` (차단), `"ask"` (사용자 확인) |
| `permissionDecisionReason` | allow/ask: 사용자에게 표시, deny: Claude에게 전달 |
| `updatedInput` | 도구 입력 파라미터 수정 |
| `additionalContext` | Claude 컨텍스트에 문자열 추가 |

**주요 도구 입력 스키마:**

- **Bash**: `command`, `description`, `timeout`, `run_in_background`
- **Write**: `file_path`, `content`
- **Edit**: `file_path`, `old_string`, `new_string`, `replace_all`
- **Read**: `file_path`, `offset`, `limit`

### PermissionRequest

권한 대화상자가 표시될 때 발생.

- **차단**: 가능
- **Matcher**: 도구명

**hookSpecificOutput.decision 필드:**

| 필드 | 설명 |
|------|------|
| `behavior` | `"allow"` 또는 `"deny"` |
| `updatedInput` | allow 시 도구 입력 수정 |
| `updatedPermissions` | allow 시 권한 규칙 업데이트 적용 |
| `message` | deny 시 Claude에게 전달할 메시지 |
| `interrupt` | deny 시 `true`이면 Claude 중단 |

### PostToolUse

도구 호출 성공 후 발생.

- **차단**: 도구 실행 차단 불가 (이미 완료). 단, `decision: "block"`으로 후속 처리 중단 가능
- **Matcher**: 도구명

### PostToolUseFailure

도구 호출 실패 후 발생.

- **차단**: 불가
- **Matcher**: 도구명

### Notification

Claude가 알림을 보낼 때 발생.

- **차단**: 불가
- **Matcher**: `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`

### SubagentStart

서브에이전트 생성 시 발생.

- **차단**: 불가
- **Matcher**: 에이전트 타입 (예: `Bash`, `Explore`, `Plan`, 커스텀명)

### SubagentStop

서브에이전트 완료 시 발생.

- **차단**: 가능
- **Matcher**: 에이전트 타입
- **차단 방식**: 최상위 `decision: "block"` + `reason`

### Stop

Claude 응답 완료 시 발생.

- **차단**: 가능
- **Matcher**: 없음
- **차단 방식**: 최상위 `decision: "block"` + `reason`
- **주의**: 입력에 `stop_hook_active` boolean 포함. 무한 루프 방지를 위해 반드시 체크.

### TeammateIdle

에이전트 팀 동료가 유휴 상태로 전환 직전에 발생.

- **차단**: 가능 (exit 2로 차단, stderr가 피드백)
- **Matcher**: 없음

### TaskCompleted

태스크가 완료 상태로 마킹될 때 발생.

- **차단**: 가능 (exit 2로 차단, stderr가 피드백)
- **Matcher**: 없음

### PreCompact

컨텍스트 압축 전에 발생.

- **차단**: 불가
- **Matcher**: `manual`, `auto`

### SessionEnd

세션 종료 시 발생.

- **차단**: 불가
- **Matcher**: `clear`, `logout`, `prompt_input_exit`, `bypass_permissions_disabled`, `other`

---

## Hook Handler Fields

### Command Hook (`type: "command"`)

| 필드 | 필수 | 설명 | 기본값 |
|------|------|------|--------|
| `type` | O | `"command"` | - |
| `command` | O | 실행할 셸 명령 | - |
| `timeout` | X | 취소 전 대기 초 | 600 |
| `statusMessage` | X | 실행 중 스피너 메시지 | - |
| `once` | X | `true`: 세션당 1회만 실행 (스킬 전용) | false |
| `async` | X | `true`: 백그라운드 실행, 차단 불가 | false |

### Prompt Hook (`type: "prompt"`)

| 필드 | 필수 | 설명 | 기본값 |
|------|------|------|--------|
| `type` | O | `"prompt"` | - |
| `prompt` | O | LLM에 전달할 프롬프트. `$ARGUMENTS`로 훅 입력 JSON 접근 | - |
| `model` | X | 사용 모델 | fast model |
| `timeout` | X | 대기 초 | 30 |
| `statusMessage` | X | 스피너 메시지 | - |

응답 스키마: `{ "ok": true|false, "reason": "..." }`

### Agent Hook (`type: "agent"`)

| 필드 | 필수 | 설명 | 기본값 |
|------|------|------|--------|
| `type` | O | `"agent"` | - |
| `prompt` | O | 검증 대상 설명 프롬프트 | - |
| `model` | X | 사용 모델 | fast model |
| `timeout` | X | 대기 초 | 60 |
| `statusMessage` | X | 스피너 메시지 | - |

에이전트 훅은 Read, Grep, Glob 도구를 최대 50턴까지 사용 가능.

---

## Common Input Fields (전 이벤트 공통)

| 필드 | 설명 |
|------|------|
| `session_id` | 현재 세션 ID |
| `transcript_path` | 대화 JSON 경로 |
| `cwd` | 현재 작업 디렉토리 |
| `permission_mode` | 현재 권한 모드 |
| `hook_event_name` | 발생한 이벤트 이름 |

---

## JSON Output Fields (범용)

| 필드 | 기본값 | 설명 |
|------|--------|------|
| `continue` | `true` | `false` 시 Claude 처리 완전 중단 |
| `stopReason` | - | `continue: false` 시 사용자에게 표시할 메시지 |
| `suppressOutput` | `false` | `true` 시 verbose 모드에서 stdout 숨김 |
| `systemMessage` | - | 사용자에게 표시할 경고 메시지 |

---

## Matcher Patterns

정규식 문자열. `"*"`, `""`, 또는 생략 시 모든 대상에 매칭.

MCP 도구 패턴: `mcp__<server>__<tool>`
