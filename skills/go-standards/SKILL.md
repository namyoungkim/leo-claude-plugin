---
name: go-standards
description: Go 프로젝트의 코딩 표준, 프로젝트 세팅, 패턴 가이드. go mod + golangci-lint + gofmt 기반.
---

# Go 코딩 표준

## Go 설계 철학

3대 핵심: **단순함(Simplicity)**, **실용성(Pragmatism)**, **병행성(Concurrency)**

### Go Proverbs (핵심 격언)

| 격언 | 적용 |
|------|------|
| **Clear is better than clever** | 명확한 코드 > 영리한 코드, 한 줄 트릭 지양 |
| **Errors are values** | 에러를 값으로 다루고, `_`로 무시 금지 |
| **Don't panic** | panic 남용 금지, `error` 반환 우선 |
| **Make the zero value useful** | 구조체 제로값이 유효하도록 설계 |
| **The bigger the interface, the weaker the abstraction** | 인터페이스는 1-3개 메서드, 작을수록 좋음 |
| **A little copying is better than a little dependency** | 작은 복사 > 작은 의존성 |
| **Don't communicate by sharing memory** | channel로 통신, 공유 메모리 지양 |

### 핵심 원칙

**1. 명확함 > 영리함**
```go
// ❌ 한 줄에 모든 것
users := filter(users, func(u *User) bool { return u != nil && u.Active && time.Since(u.LastLogin) < 24*time.Hour })

// ✅ 단계별로 명확하게
func isRecentlyActiveUser(u *User) bool {
    if u == nil {
        return false
    }
    if !u.Active {
        return false
    }
    return time.Since(u.LastLogin) < 24*time.Hour
}
activeUsers := filter(users, isRecentlyActiveUser)
```

**2. 에러를 숨기지 마라 (3단계)**
1. 에러 확인: `if err != nil`
2. 컨텍스트 추가: `fmt.Errorf("무슨 작업 중: %w", err)`
3. 적절히 반환 또는 로깅

**3. 작은 인터페이스**
```go
// ✅ 메서드 1개 — 구현하기 쉽고 조합하기 좋음
type Reader interface {
    Read(id string) ([]byte, error)
}
type Writer interface {
    Write(id string, data []byte) error
}

// ❌ 메서드 8개 — 구현 부담, 테스트 어려움
type DataStore interface { Create(); Read(); Update(); Delete(); List(); Search(); Backup(); Restore() }
```

### Go vs 다른 언어 차이점
- 예외(Exception) 대신 **에러 값 반환** (`error` 타입)
- 상속 대신 **조합(Composition)** (struct embedding)
- 제네릭보다 **인터페이스** 우선 고려

---

## 프로젝트 초기화

```bash
# 모듈 초기화
mkdir my-project && cd my-project
go mod init github.com/username/my-project

# 디렉토리 구조 생성
mkdir -p cmd/server internal/{handler,service,repository,model}

# golangci-lint 설치
go install github.com/golangci-lint/golangci-lint/cmd/golangci-lint@latest
```

## .golangci.yml 표준

```yaml
run:
  timeout: 5m

linters:
  enable:
    - errcheck
    - govet
    - staticcheck
    - unused
    - gosimple
    - ineffassign
    - gofmt
    - goimports
    - misspell

linters-settings:
  errcheck:
    check-blank: true
  govet:
    check-shadowing: true
```

## 함수 작성 표준

```go
// GetUserByEmail 은 이메일로 사용자를 조회한다.
// 사용자가 없으면 ErrNotFound를 반환한다.
func (s *UserService) GetUserByEmail(ctx context.Context, email string) (*User, error) {
	user, err := s.repo.FindByEmail(ctx, email)
	if err != nil {
		return nil, fmt.Errorf("사용자 조회 실패 (email=%s): %w", email, err)
	}

	if user == nil {
		return nil, ErrNotFound
	}

	return user, nil
}
```

## 에러 핸들링 표준

```go
import "errors"

var (
	ErrNotFound     = errors.New("리소스를 찾을 수 없습니다")
	ErrUnauthorized = errors.New("인증에 실패했습니다")
	ErrForbidden    = errors.New("권한이 없습니다")
)

// 에러 래핑
if err != nil {
	return fmt.Errorf("DB 쿼리 실패: %w", err)
}

// 에러 검사
if errors.Is(err, ErrNotFound) {
	http.Error(w, "Not Found", http.StatusNotFound)
}
```

## 테스트 표준

```go
func TestGetUserByEmail(t *testing.T) {
	tests := []struct {
		name    string
		email   string
		want    *User
		wantErr error
	}{
		{
			name:  "존재하는 이메일로 사용자 반환",
			email: "test@example.com",
			want:  &User{ID: "1", Email: "test@example.com"},
		},
		{
			name:    "존재하지 않는 이메일이면 에러",
			email:   "없는@이메일.com",
			wantErr: ErrNotFound,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			svc := NewUserService(mockRepo)
			got, err := svc.GetUserByEmail(context.Background(), tt.email)

			if tt.wantErr != nil {
				if !errors.Is(err, tt.wantErr) {
					t.Errorf("want error %v, got %v", tt.wantErr, err)
				}
				return
			}

			if got.ID != tt.want.ID {
				t.Errorf("want ID %s, got %s", tt.want.ID, got.ID)
			}
		})
	}
}
```
