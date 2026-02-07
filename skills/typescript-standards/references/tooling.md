# TypeScript Tooling Reference

Extended reference for tools mentioned in SKILL.md.

## pnpm

빠르고 디스크 효율적인 패키지 매니저.

```bash
# 프로젝트 초기화
pnpm init

# 의존성 추가
pnpm add express
pnpm add -D typescript @types/node
pnpm add -D eslint prettier vitest

# 의존성 제거
pnpm remove express

# 설치 (lockfile 기반)
pnpm install

# 스크립트 실행
pnpm run build
pnpm exec tsc --noEmit
```

### pnpm-lock.yaml

- 자동 생성, 수동 편집 금지
- Git에 커밋 (재현성 보장)

## eslint

TypeScript 린터.

```bash
# 린트 검사
pnpm exec eslint .

# 자동 수정
pnpm exec eslint . --fix

# 특정 파일
pnpm exec eslint src/index.ts
```

### eslint.config.js (Flat Config)

```javascript
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      '@typescript-eslint/no-unused-vars': 'error',
      '@typescript-eslint/explicit-function-return-type': 'warn',
    },
  },
);
```

## prettier

코드 포맷터.

```bash
# 포맷 적용
pnpm exec prettier --write .

# 포맷 검사
pnpm exec prettier --check .
```

### .prettierrc

```json
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
```

### eslint vs prettier

| Tool | Purpose | When |
|------|---------|------|
| eslint | 코드 품질 (버그, 패턴) | 로직 관련 규칙 |
| prettier | 코드 스타일 (포맷팅) | 외관 관련 규칙 |

충돌 방지: `eslint-config-prettier` 사용

## vitest

Vite 기반 테스트 프레임워크. Jest 호환 API.

```bash
# 전체 테스트
pnpm exec vitest run

# Watch 모드
pnpm exec vitest

# 특정 파일
pnpm exec vitest run src/utils.test.ts

# 커버리지
pnpm exec vitest run --coverage

# UI 모드
pnpm exec vitest --ui
```

### vitest.config.ts (선택)

```typescript
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
    },
  },
});
```

## tsc

TypeScript 컴파일러.

```bash
# 타입 검사만 (빌드 없음)
pnpm exec tsc --noEmit

# 빌드
pnpm exec tsc

# Watch 모드
pnpm exec tsc --watch

# tsconfig 초기화
npx tsc --init
```
