## 네이밍 규칙 (Python)

| 대상 | 규칙 | 예시 |
|------|------|------|
| 파일명 | snake_case | `user_service.py` |
| 클래스 | PascalCase | `UserService` |
| 함수/변수 | snake_case | `get_user_by_id` |
| 상수 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Pydantic 모델 | PascalCase + 접미사 | `UserCreateRequest`, `UserResponse` |
| SQLAlchemy 모델 | PascalCase 단수 | `User`, `StockPrice` |

## Import 정렬 (Python)
ruff가 자동 정렬. 수동 편집 금지.
순서: stdlib → third-party → local

## 커밋 메시지
Conventional Commits: `<type>(<scope>): <description>`
타입: feat, fix, refactor, test, docs, chore, ci

## 에러 핸들링 (Python)
- 구체적 예외 타입만 사용 (bare Exception 금지)
- 예외 체이닝: `from e` 사용
- structlog 또는 logging 사용
- 사용자 노출 에러에 내부 상세 숨기기

## API 응답 형식
```json
// 성공
{"data": {...}, "meta": {"page": 1, "total": 100}}

// 에러
{"detail": "error message", "code": "ERROR_CODE"}
```
