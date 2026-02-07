## 네이밍 규칙 (Go)

| 대상 | 규칙 | 예시 |
|------|------|------|
| 파일명 | snake_case | `user_service.go` |
| 패키지명 | lowercase (언더스코어 없음) | `userservice` |
| 구조체 | PascalCase | `UserService` |
| 함수 (공개) | PascalCase | `GetUserByID` |
| 함수 (비공개) | camelCase | `getUserByID` |
| 상수 (공개) | PascalCase | `DefaultTimeout` |
| 인터페이스 | PascalCase, 보통 `-er` 접미사 | `Reader`, `UserRepository` |

## 에러 핸들링 (Go)
```go
if err != nil {
    return fmt.Errorf("작업 실패: %w", err)
}
```
- 에러 래핑: `%w` 포맷 동사 사용
- 커스텀 에러: `errors.New()` 또는 타입 정의
- 에러 검사: `errors.Is()`, `errors.As()`

## 테스트 규칙 (Go)
- 테스트 파일: `main.go` → `main_test.go`
- 테스트 함수: `TestFunctionName(t *testing.T)`
- 테이블 주도 테스트로 여러 시나리오 커버
- 벤치마크: `BenchmarkFunctionName(b *testing.B)`

## 커밋 메시지
Conventional Commits: `<type>(<scope>): <description>`
타입: feat, fix, refactor, test, docs, chore, ci

## 프로젝트 구조
```
cmd/
├── server/
│   └── main.go       ← 엔트리포인트
internal/
├── handler/           ← HTTP 핸들러
├── service/           ← 비즈니스 로직
├── repository/        ← 데이터 접근
└── model/             ← 도메인 모델
pkg/                   ← 외부 공개 패키지 (선택)
```
