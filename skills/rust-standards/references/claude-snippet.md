## Rust 스택
- 패키지: cargo
- 린터: clippy
- 포맷터: rustfmt
- 테스트: cargo test
- 프로젝트: Cargo.toml 기반, src/ 레이아웃

## 절대 규칙 (Rust)
- NEVER: 프로덕션 코드에서 `unwrap()` 사용, 라이브러리에서 `panic!`
- NEVER: 충분한 검토/문서화 없이 `unsafe` 사용, 글로벌 mutable 상태
- ALWAYS: 구조체에 `#[derive(Debug)]`, Result<T, E>로 에러 처리
- ALWAYS: 네거티브 테스트 케이스 포함, 커밋 메시지 conventional commits

## 코드 작성 시 (Rust)
- 명시적 루프보다 이터레이터 선호
- `unwrap()` 대신 `Result`/`Option` 조합 사용
- 모든 경우가 중요하면 `if let` 대신 `match` 사용
- `unsafe` 코드는 반드시 상세 문서화
