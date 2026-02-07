---
name: rust-standards
description: Rust 프로젝트의 코딩 표준, 프로젝트 세팅, 패턴 가이드. cargo + clippy + rustfmt 기반.
---

# Rust 코딩 표준

## 프로젝트 초기화

```bash
# 라이브러리
cargo init --lib my-project

# 바이너리
cargo init my-project

# 워크스페이스
mkdir my-workspace && cd my-workspace
cargo init --lib crates/core
cargo init crates/cli
```

## Cargo.toml 표준

```toml
[package]
name = "my-project"
version = "0.1.0"
edition = "2021"
rust-version = "1.75"

[dependencies]
tokio = { version = "1", features = ["full"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
thiserror = "1"
tracing = "0.1"

[dev-dependencies]
tokio-test = "0.4"

[lints.rust]
unsafe_code = "forbid"

[lints.clippy]
all = { level = "warn", priority = -1 }
pedantic = { level = "warn", priority = -1 }
```

## 함수 작성 표준

```rust
/// 사용자를 이메일로 조회한다.
///
/// # Errors
/// - `UserError::NotFound` — 해당 이메일의 사용자가 없을 때
/// - `UserError::Database` — DB 연결 실패 시
pub async fn get_user_by_email(
    pool: &PgPool,
    email: &str,
) -> Result<User, UserError> {
    let user = sqlx::query_as!(User, "SELECT * FROM users WHERE email = $1", email)
        .fetch_optional(pool)
        .await
        .map_err(UserError::Database)?;

    user.ok_or(UserError::NotFound)
}
```

## 에러 핸들링 표준

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("사용자를 찾을 수 없습니다: {0}")]
    NotFound(String),

    #[error("데이터베이스 에러")]
    Database(#[from] sqlx::Error),

    #[error("인증 실패")]
    Unauthorized,
}
```

## 테스트 표준

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_get_user_by_email_returns_user() {
        let pool = setup_test_db().await;
        let user = create_test_user(&pool).await;

        let result = get_user_by_email(&pool, &user.email).await;

        assert!(result.is_ok());
        assert_eq!(result.unwrap().id, user.id);
    }

    #[tokio::test]
    async fn test_get_user_by_email_returns_not_found() {
        let pool = setup_test_db().await;

        let result = get_user_by_email(&pool, "없는@이메일.com").await;

        assert!(matches!(result, Err(UserError::NotFound)));
    }
}
```
