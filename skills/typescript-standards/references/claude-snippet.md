## TypeScript 스택
- 패키지: pnpm
- 린터: eslint
- 포맷터: prettier
- 테스트: vitest
- 프로젝트: tsconfig.json 기반, src/ 레이아웃

## 절대 규칙 (TypeScript)
- NEVER: `any` 타입 사용, `console.log` 디버깅, 하드코딩된 환경변수
- NEVER: `var` 키워드, TS 파일에서 `require()`, 테스트 없는 커밋
- ALWAYS: strict 모드 tsconfig, 함수 파라미터/리턴 타입 명시
- ALWAYS: `const`/`let` 사용, 커밋 메시지 conventional commits

## 코드 작성 시 (TypeScript)
- tsconfig에서 strict 모드 활성화
- 객체 타입은 `interface`, 유니온은 `type` 선호
- `.then()` 대신 `async`/`await` 사용
- `as const` 단언으로 리터럴 타입 활용
