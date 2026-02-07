# Go Tooling Reference

Extended reference for tools mentioned in SKILL.md.

## go mod

Go 내장 모듈 시스템.

```bash
# 모듈 초기화
go mod init github.com/username/project

# 의존성 추가 (import 후 자동)
go mod tidy

# 의존성 다운로드
go mod download

# 의존성 벤더링
go mod vendor

# 의존성 그래프
go mod graph
```

### go.sum

- 자동 생성, 수동 편집 금지
- Git에 커밋 (재현성 보장)

## golangci-lint

메타 린터. 여러 린터를 통합 실행.

```bash
# 전체 린트
golangci-lint run ./...

# 빠른 모드
golangci-lint run --fast ./...

# 특정 린터만
golangci-lint run --enable errcheck ./...

# 자동 수정
golangci-lint run --fix ./...
```

### 주요 린터

| Linter | Description |
|--------|-------------|
| `errcheck` | 에러 리턴값 무시 탐지 |
| `govet` | Go vet 검사 (shadowing 포함) |
| `staticcheck` | 정적 분석 (고급) |
| `unused` | 사용하지 않는 코드 탐지 |
| `gosimple` | 단순화 가능한 코드 탐지 |
| `gofmt` | 포맷 일관성 검사 |
| `goimports` | import 정렬 검사 |
| `misspell` | 오타 탐지 |

## gofmt / goimports

```bash
# 포맷 검사 (변경할 파일 목록)
gofmt -l .

# 포맷 적용
gofmt -w .

# goimports (import 정렬 포함)
goimports -w .
```

### gofmt vs goimports

| Tool | Purpose | When |
|------|---------|------|
| gofmt | 코드 포맷팅 | 기본 포맷터 |
| goimports | gofmt + import 정렬 | 추천 (VSCode에서 기본) |

## go test

```bash
# 전체 테스트
go test ./...

# 특정 패키지
go test ./internal/service/...

# Verbose
go test -v ./...

# 특정 테스트 함수
go test -run TestGetUser ./...

# 커버리지
go test -cover ./...
go test -coverprofile=coverage.out ./...
go tool cover -html=coverage.out

# 벤치마크
go test -bench=. ./...

# Race condition 탐지
go test -race ./...
```
