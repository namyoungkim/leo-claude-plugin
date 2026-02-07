## 네이밍 규칙 (Rust)

| 대상 | 규칙 | 예시 |
|------|------|------|
| 파일명 | snake_case | `user_service.rs` |
| 모듈 | snake_case | `mod user_service` |
| 구조체/열거형 | PascalCase | `UserService`, `UserRole` |
| 함수/변수 | snake_case | `get_user_by_id` |
| 상수 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| 트레이트 | PascalCase | `UserRepository` |
| 타입 파라미터 | 대문자 단일 | `T`, `E`, `K`, `V` |

## 에러 핸들링 (Rust)
- `Result<T, E>` 타입으로 복구 가능한 에러 처리
- 커스텀 에러에 `Display` impl
- `thiserror` (라이브러리) 또는 `anyhow` (바이너리) 크레이트 사용
- 테스트/예시 외에서 `unwrap()` 금지

## 테스트 규칙 (Rust)
- 유닛 테스트: 같은 파일 내 `#[cfg(test)]` 모듈
- 통합 테스트: `tests/` 디렉토리
- 직렬 실행 필요 시: `cargo test -- --test-threads=1`
- 테스트 함수명: `test_기능_조건_기대결과` 패턴

## 커밋 메시지
Conventional Commits: `<type>(<scope>): <description>`
타입: feat, fix, refactor, test, docs, chore, ci

## 프로젝트 구조
```
src/
├── main.rs 또는 lib.rs
├── error.rs          ← 커스텀 에러 타입
├── config.rs         ← 설정 관리
└── modules/
    ├── mod.rs
    └── feature.rs
tests/
└── integration_test.rs
```
