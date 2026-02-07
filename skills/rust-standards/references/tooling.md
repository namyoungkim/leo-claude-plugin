# Rust Tooling Reference

Extended reference for tools mentioned in SKILL.md.

## cargo

Rust 패키지 매니저 + 빌드 시스템.

```bash
# 프로젝트 초기화
cargo init             # 바이너리
cargo init --lib       # 라이브러리

# 의존성 추가
cargo add tokio --features full
cargo add serde --features derive
cargo add --dev tokio-test

# 빌드
cargo build            # 디버그
cargo build --release  # 릴리즈

# 실행
cargo run
cargo run --release

# 업데이트
cargo update           # 모든 의존성
cargo update -p serde  # 특정 의존성
```

### Cargo.lock

- 바이너리: Git에 커밋
- 라이브러리: `.gitignore`에 추가

## clippy

Rust 공식 린터. 500+ 린트 규칙 제공.

```bash
# 기본 검사
cargo clippy

# 모든 타겟 + 피처
cargo clippy --all-targets --all-features

# 경고를 에러로
cargo clippy -- -D warnings

# 특정 린트 허용
cargo clippy -- -A clippy::too_many_arguments
```

### 주요 린트 그룹

| Group | Description |
|-------|-------------|
| `clippy::all` | 모든 기본 린트 |
| `clippy::pedantic` | 엄격한 린트 (권장) |
| `clippy::nursery` | 실험적 린트 |
| `clippy::cargo` | Cargo.toml 관련 린트 |

## rustfmt

```bash
# 포맷 적용
cargo fmt

# 포맷 검사 (변경 없음)
cargo fmt --check

# 특정 파일
rustfmt src/main.rs
```

### rustfmt.toml (선택)

```toml
edition = "2021"
max_width = 100
tab_spaces = 4
use_field_init_shorthand = true
```

## cargo test

```bash
# 전체 테스트
cargo test

# 특정 테스트
cargo test test_get_user

# 특정 모듈
cargo test service::tests

# 직렬 실행
cargo test -- --test-threads=1

# 출력 보기
cargo test -- --nocapture

# 벤치마크
cargo bench

# Doc 테스트
cargo test --doc
```
