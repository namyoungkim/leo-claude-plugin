# Common Python Pitfalls

Hard-won patterns harvested from production projects. Each item includes the gotcha, the safe pattern, and why it matters.

## SQLite write-permission check creates the file as a side effect

`sqlite3.connect(path)` creates an empty DB file when `path` does not exist. Tests that probe "can I write a DB here?" by calling `connect()` therefore leave the file behind, polluting fixtures that assume the directory is empty.

```python
# Side-effect-free check
cfg = Config(root=tmp_path)
db_path = cfg.index_db
if db_path.exists():
    db_path.unlink()  # clean up if a probe ran earlier
```

**Rule**: Treat `sqlite3.connect()` as write-creating. If a probe is unavoidable, clean up immediately and document the side effect at the call site.

## HTTP request error-handling checklist

When fetching with `urllib`/`requests`/`httpx`, every external call needs four guarantees:

```python
try:
    req = urllib.request.Request(url)
    with urllib.request.urlopen(req, timeout=10) as resp:
        if resp.status != 200:
            raise ValueError(f"HTTP {resp.status}: {url}")
        data = json.loads(resp.read().decode())
except urllib.error.URLError as e:
    raise ValueError(f"HTTP request failed: {url}") from e
try:
    return data["info"]["version"]
except KeyError as e:
    raise ValueError(f"Unexpected response shape: {url}") from e
```

**Required**:
- `timeout` always set (no infinite hangs).
- Status check — non-200 redirects/error pages also reach the parser otherwise.
- JSON parse failure → `ValueError` with `from e` so the caller sees the original cause.
- Schema access (`data["info"]["version"]`) wrapped separately — distinguishes transport failure from response-shape failure.

## YAML required-field validation

`yaml.safe_load()` returns `None`/`""` for empty or missing scalar fields. Both are valid YAML but usually invalid for the application:

```python
current_version = data.get("version")
if not current_version:
    raise ValueError(f"No 'version' in {yaml_path}")
```

`not value` catches both `None` and `""`. Validate immediately after parse — failing fast at the boundary keeps downstream code honest.

## Project-root resolution with environment-variable override

CLI tools installed globally need a way to point at a specific project without `cd`. Standard pattern: env var first, cwd-walk fallback, validate either way:

```python
def find_project_root(start: Path | None = None) -> Path:
    env_root = os.environ.get("KB_ROOT")
    if env_root:
        root = Path(env_root).resolve()
        if (root / "cards").is_dir():  # validate marker exists
            return root
    current = (start or Path.cwd()).resolve()
    for parent in [current, *current.parents]:
        if (parent / "cards").is_dir():
            return parent
    return current
```

**Rules**:
- Validate the env-var path against a sentinel directory — never trust it blindly.
- Keep the cwd-walk fallback so existing callers keep working.
- Always `resolve()` to absolute paths before returning.
- When introducing a new env var, audit existing tests and add `monkeypatch.delenv("VAR_NAME")` to any test that depends on the default resolution — otherwise CI/local divergence is silent.

## YAML format-preserving writes (text-based replacement)

`yaml.dump()` rewrites the entire file, dropping comments, normalising quote styles, and re-flowing indentation. For single-field updates (`last_version_check`, `last_modified`, etc.), use a regex replacement to preserve the surrounding format:

```python
import re

def _replace_yaml_line(text: str, key: str, new_value: str) -> str:
    """Replace value of a top-level key, preserving comments and quoting."""
    return re.sub(
        rf"^({re.escape(key)}:\s*).*$",
        rf"\g<1>{new_value}",
        text, count=1, flags=re.MULTILINE,
    )

raw = yaml_path.read_text()
raw = _replace_yaml_line(raw, "last_version_check", "2026-02-09")
yaml_path.write_text(raw)
```

**When to use which**:
- Single field update → text replacement (diff-friendly, preserves comments).
- Structural change (new section, list append) → `yaml.safe_dump()` is fine — but expect comment loss and review the diff for unintended re-flowing.

## pytest fixture types

Type pytest fixtures with the public `pytest.{Name}` aliases instead of `object`:

```python
def test_x(monkeypatch: pytest.MonkeyPatch, tmp_path: Path) -> None: ...
def test_y(request: pytest.FixtureRequest) -> None: ...
```

`object` typing forces `# type: ignore` on every `setenv`/`delenv` call and disables type-checker help where it matters most.
