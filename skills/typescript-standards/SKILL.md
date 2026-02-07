---
name: typescript-standards
description: "TypeScript 프로젝트의 코딩 표준, 프로젝트 세팅, 패턴 가이드. pnpm + eslint + prettier + vitest 기반. 트리거: TypeScript 프로젝트, tsconfig.json, eslint, prettier, vitest, TypeScript 코딩 표준, TS 세팅"
user-invocable: false
---

# TypeScript 코딩 표준

## 프로젝트 초기화

```bash
# 프로젝트 생성
mkdir my-project && cd my-project
pnpm init

# 핵심 의존성
pnpm add -D typescript @types/node
pnpm add -D eslint prettier vitest
pnpm add -D @typescript-eslint/parser @typescript-eslint/eslint-plugin

# tsconfig 초기화
npx tsc --init
```

## tsconfig.json 표준

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

## 함수 작성 표준

```typescript
/**
 * 이메일로 사용자를 조회한다.
 *
 * @param email - 조회할 사용자 이메일
 * @returns 사용자 객체
 * @throws {NotFoundError} 사용자가 존재하지 않을 때
 */
export async function getUserByEmail(
  email: string,
): Promise<User> {
  const user = await db.user.findUnique({
    where: { email },
  });

  if (!user) {
    throw new NotFoundError(`User not found: ${email}`);
  }

  return user;
}
```

## 에러 핸들링 표준

```typescript
export class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

export class NotFoundError extends AppError {
  constructor(message: string) {
    super(message, 'NOT_FOUND', 404);
  }
}
```

## VSCode settings.json (프로젝트 레벨)

`.vscode/settings.json` 생성:

```jsonc
{
    // TypeScript + Prettier + ESLint
    "typescript.tsdk": "node_modules/typescript/lib",
    "[typescript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
            "source.fixAll.eslint": "explicit",
            "source.organizeImports": "explicit"
        }
    },
    "[typescriptreact]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode",
        "editor.formatOnSave": true
    },
    // File exclusions
    "files.exclude": {
        "**/node_modules": true,
        "**/dist": true
    }
}
```

Required Extensions: `esbenp.prettier-vscode`, `dbaeumer.vscode-eslint`

## 테스트 표준

```typescript
import { describe, it, expect, vi } from 'vitest';

describe('getUserByEmail', () => {
  it('존재하는 이메일로 사용자를 반환한다', async () => {
    const mockUser = { id: '1', email: 'test@example.com' };
    vi.spyOn(db.user, 'findUnique').mockResolvedValue(mockUser);

    const result = await getUserByEmail('test@example.com');

    expect(result).toEqual(mockUser);
  });

  it('존재하지 않는 이메일이면 NotFoundError를 던진다', async () => {
    vi.spyOn(db.user, 'findUnique').mockResolvedValue(null);

    await expect(
      getUserByEmail('없는@이메일.com'),
    ).rejects.toThrow(NotFoundError);
  });
});
```

## Workflow Checklist

프로젝트 생성:

- [ ] `pnpm init` 실행
- [ ] `pnpm add -D typescript @types/node eslint prettier vitest`
- [ ] `npx tsc --init`으로 tsconfig.json 생성
- [ ] `.vscode/settings.json` 생성
- [ ] `src/` 디렉토리 구조 생성

코드 작성:

- [ ] strict 모드 타입 체크
- [ ] 함수 파라미터/리턴 타입 명시
- [ ] `async`/`await` 사용 (`.then()` 금지)
- [ ] 함수 20-50줄 유지

커밋 전:

- [ ] `pnpm exec eslint . --fix`
- [ ] `pnpm exec prettier --write .`
- [ ] `pnpm exec vitest run`
- [ ] `pnpm exec tsc --noEmit`
