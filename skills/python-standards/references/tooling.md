# Python Tooling Reference

Extended reference for tools mentioned in SKILL.md.

## uv

Rust-based package manager. Replaces pip + venv + pyenv.

```bash
# Project initialization
uv init              # Default (app)
uv init --lib        # Library (src layout)

# Dependencies
uv add requests      # Runtime dependency
uv add --dev pytest  # Dev dependency
uv remove requests   # Remove

# Environment
uv sync              # Sync from lockfile
uv lock              # Update lockfile only

# Run
uv run python main.py
uv run pytest
```

### uv.lock

- Auto-generated, do not edit manually
- Commit to Git (ensures reproducibility)

## ruff

Rust-based linter + formatter. Replaces flake8 + isort + black.

```bash
# Lint
ruff check .              # Check
ruff check --fix .        # Auto-fix
ruff check --watch .      # Watch mode

# Format
ruff format .             # Format all
ruff format --check .     # Check only (no changes)
```

### Rule Groups

| Rule | Description |
|------|-------------|
| `E`, `W` | pycodestyle (PEP8 errors/warnings) |
| `F` | Pyflakes (unused imports, etc.) |
| `I` | isort (import sorting) |
| `B` | flake8-bugbear (common bug patterns) |
| `C4` | flake8-comprehensions |
| `UP` | pyupgrade (modern syntax) |
| `SIM` | flake8-simplify (code simplification) |
| `TCH` | flake8-type-checking (TYPE_CHECKING imports) |
| `PTH` | flake8-use-pathlib (Path over os.path) |
| `ASYNC` | flake8-async (async best practices) |
| `RUF` | Ruff-specific rules |

## ty

Astral's type checker. Aims to replace mypy/pyright.

```bash
ty check              # Check all
ty check src/         # Check specific path
```

### ty vs Pylance

| Tool | Purpose | When |
|------|---------|------|
| Pylance | Real-time feedback, autocomplete | While coding |
| ty | Full project check, CI | Before commit, CI |

They are complementary, not redundant.

## pytest

```bash
# Basic
pytest                    # All tests
pytest tests/test_main.py # Specific file
pytest -k "test_add"      # Name pattern

# Options
pytest -v                 # Verbose
pytest -x                 # Stop on first failure
pytest --lf               # Last failed only
pytest --cov=src          # Coverage

# Markers
pytest -m "slow"          # Only marked tests
pytest -m "not slow"      # Exclude marked tests
```

### Test Structure

```python
# tests/test_example.py
import pytest
from package_name.main import add

def test_add_positive():
    assert add(1, 2) == 3

def test_add_negative():
    assert add(-1, -2) == -3

@pytest.mark.slow
def test_slow_operation():
    ...

@pytest.fixture
def sample_data():
    return {"key": "value"}

def test_with_fixture(sample_data):
    assert sample_data["key"] == "value"
```

## pre-commit (Optional)

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.14.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
```

```bash
uv add --dev pre-commit
uv run pre-commit install
```
