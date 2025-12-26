---
name: python-project
description: Python project initialization and setup guide. Uses uv + ruff + ty + pytest based Astral Toolchain. Triggers on project creation, pyproject.toml configuration, VSCode settings, code conventions. Use for requests like "create Python project", "Python setup", "initialize new project".
---

# Python Project Setup

Leo's Python project standard setup. Based on Astral Toolchain (uv + ruff + ty).

## Tool Stack

| Tool | Purpose | Version |
|------|---------|---------|
| uv | Package manager + project management | latest |
| ruff | Linter + Formatter | >=0.14 |
| ty | Type Checker (CLI) | >=0.0.7 (Beta) |
| pytest | Testing | >=8.0 |
| Pylance | VSCode LSP (stable) | - |

## Project Structure

```
project-name/
├── pyproject.toml
├── uv.lock
├── .python-version
├── .venv/
├── README.md
├── src/
│   └── project_name/
│       ├── __init__.py
│       └── py.typed
└── tests/
    └── test_example.py
```

## Initialization Commands

```bash
# Library project
uv init --lib project-name
cd project-name

# Add dev tools
uv add --dev ruff ty pytest

# Run
uv run python -m project_name
uv run pytest
uv run ruff check .
uv run ty check
```

## pyproject.toml Template

> Full template available at `assets/pyproject-template.toml`

```toml
[project]
name = "project-name"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = []

[dependency-groups]
dev = [
    "ruff>=0.14",
    "ty>=0.0.7",
    "pytest>=8.0",
]

# ===== Ruff =====
[tool.ruff]
line-length = 88
target-version = "py311"
exclude = [".venv", "venv", "__pycache__", "build", "dist"]

[tool.ruff.lint]
select = ["E", "W", "F", "B", "I", "C4", "UP", "SIM", "TCH", "PTH", "ASYNC", "RUF"]
ignore = ["E501", "B008"]
fixable = ["ALL"]

[tool.ruff.lint.isort]
known-first-party = ["project_name"]

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["B011"]
"__init__.py" = ["F401"]

[tool.ruff.format]
quote-style = "double"
docstring-code-format = true

# ===== ty =====
[tool.ty]
# ty auto-detects requires-python

[tool.ty.src]
exclude = ["tests/fixtures/**"]
```

## VSCode settings.json (Project-level)

Create `.vscode/settings.json`:

```jsonc
{
    // Python + Ruff
    "python.analysis.typeCheckingMode": "basic",
    "python.analysis.autoImportCompletions": true,
    "[python]": {
        "editor.defaultFormatter": "charliermarsh.ruff",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
            "source.fixAll.ruff": "explicit",
            "source.organizeImports.ruff": "explicit"
        }
    },
    // File exclusions
    "files.exclude": {
        "**/__pycache__": true,
        "**/.pytest_cache": true,
        "**/.ruff_cache": true
    }
}
```

Required Extensions: `ms-python.python`, `ms-python.vscode-pylance`, `charliermarsh.ruff`

## Code Philosophy

### Core Principles

1. **Explicit over Clever** - Type hints required, clear naming
2. **Fail-Fast** - Raise exceptions explicitly, don't hide errors
3. **Self-Documenting** - Comments only for "why"
4. **Design First** - Design before coding
5. **Proven over Trendy** - Prefer battle-tested tools

### Naming (PEP 8)

- Variables/functions: `snake_case`
- Classes: `PascalCase`
- Constants: `SCREAMING_SNAKE_CASE`
- Booleans: `is_`, `has_`, `can_` prefix

### Function/Module Size

- Functions: Target 20-50 lines, refactor if exceeds 100
- Modules: 200-400 lines, split if exceeds 500

### Testing

- Coverage: Target 70-80%
- Core business logic: 90%+
- Use Arrange-Act-Assert pattern

## Workflow Checklist

Project creation:

- [ ] Run `uv init --lib`
- [ ] Run `uv add --dev ruff ty pytest`
- [ ] Add tool config to pyproject.toml
- [ ] Create .vscode/settings.json
- [ ] Verify src/ layout
- [ ] Verify py.typed file exists

Writing code:

- [ ] Add type hints
- [ ] Keep functions 20-50 lines
- [ ] Verify auto-format on save

Before commit:

- [ ] `uv run ruff check --fix .`
- [ ] `uv run ruff format .`
- [ ] `uv run ty check`
- [ ] `uv run pytest`
