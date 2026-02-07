## Python 스택
- 패키지: uv (pip/poetry 대신)
- 린터/포맷터: ruff
- 타입체커: Pylance(IDE) + ty(CLI)
- 테스트: pytest
- 프로젝트: pyproject.toml 기반, src 레이아웃

## 절대 규칙 (Python)
- NEVER: `any` 타입 사용, 테스트 없는 커밋, 100줄 넘는 함수, `print()` 디버깅
- NEVER: `pip install` 직접 사용 (uv 사용), `requirements.txt` 생성
- ALWAYS: docstring 작성 (Google style), 에러 핸들링 명시
- ALWAYS: 변경 전 기존 테스트 실행, 커밋 메시지 conventional commits

## 코드 작성 시 (Python)
- import 정렬은 ruff에 위임 (수동 정리 금지)
- f-string 선호 (`.format()`, `%` 금지)
- `pathlib.Path` 사용 (`os.path` 대신)
- `dataclass` 또는 `pydantic.BaseModel` 선호 (plain dict 대신)
