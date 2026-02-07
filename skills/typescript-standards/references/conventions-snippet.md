## 네이밍 규칙 (TypeScript)

| 대상 | 규칙 | 예시 |
|------|------|------|
| 파일명 (컴포넌트) | PascalCase | `UserService.ts`, `LoginForm.tsx` |
| 파일명 (유틸) | camelCase | `formatDate.ts`, `apiClient.ts` |
| 클래스 | PascalCase | `UserService` |
| 함수/변수 | camelCase | `getUserById` |
| 상수 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| 타입/인터페이스 | PascalCase | `UserResponse`, `IUserRepository` |
| Enum | PascalCase | `UserRole` |

## Import 정렬 (TypeScript)
1. Node 표준 라이브러리
2. 외부 패키지
3. 내부 모듈 (절대 경로 `@/`)
4. 상대 경로 (`./`)

## 에러 핸들링 (TypeScript)
- 커스텀 에러: `class AppError extends Error`
- catch 절 타입: `catch (e: unknown)`
- 정리 로직: `try-finally` 사용
- API 에러: 표준 응답 형식으로 래핑

## 테스트 규칙 (TypeScript)
- 테스트 파일: `*.test.ts` 또는 `*.spec.ts`
- vitest: `describe`, `it`, `expect` 패턴
- 모킹: `vi.mock()`, `vi.spyOn()`
- 커버리지: `pnpm run test --coverage`

## 커밋 메시지
Conventional Commits: `<type>(<scope>): <description>`
타입: feat, fix, refactor, test, docs, chore, ci

## 프로젝트 구조
```
src/
├── index.ts          ← 엔트리포인트
├── types/            ← 타입 정의
├── utils/            ← 유틸리티 함수
├── services/         ← 비즈니스 로직
├── routes/ 또는 pages/ ← 라우팅
└── components/       ← UI 컴포넌트 (프론트엔드)
tests/
└── *.test.ts
```
