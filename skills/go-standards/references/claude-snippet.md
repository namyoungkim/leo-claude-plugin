## Go 스택
- 패키지: go mod
- 린터: golangci-lint
- 포맷터: gofmt (자동 적용)
- 테스트: go test (외부 프레임워크 없음)
- 프로젝트: go.mod 기반, cmd/ + internal/ 레이아웃

## 절대 규칙 (Go)
- NEVER: 프로덕션에서 `panic`, 에러 무시 (`_ = err`), 글로벌 변수
- NEVER: `init()` 남용, 불필요한 인터페이스 선언
- ALWAYS: 에러 리턴값 명시적 체크 (`if err != nil`)
- ALWAYS: 에러에 컨텍스트 추가 (`fmt.Errorf("...: %w", err)`)

## 코드 작성 시 (Go)
- 에러 핸들링: `if err != nil { return fmt.Errorf("...: %w", err) }`
- 인터페이스는 필요할 때만 선언 (소비자 측에서)
- 함수는 20줄 이내 선호
- goroutine 사용 시 반드시 context로 lifecycle 관리
