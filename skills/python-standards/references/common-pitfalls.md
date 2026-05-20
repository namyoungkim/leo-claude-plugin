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
- When dispatching parallel worktree-isolated agents, env vars that hold absolute paths (`KB_ROOT`, `PROJECT_ROOT`, etc.) must be re-exported per-worktree in each agent's prompt (`export KB_ROOT=<worktree_path>`). The parent's env var points at the original repo and is inherited silently by all child processes — `find_project_root` should walk cwd ancestry up to a sentinel directory (`.git`, `cards/`, etc.) as the authoritative resolution, making the env var an override hint rather than a hard-coded assumption.

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

## ASCII-only string validation — `isalnum()` accepts Unicode letters

`str.isalnum()` returns `True` for Hangul, CJK ideographs, accented Latin, and any other Unicode letter or digit. Using it as an "ASCII identifier" check silently lets non-ASCII slugs through:

```python
# Wrong — passes for "한글slug"
def is_valid_slug(s: str) -> bool:
    return s.replace("-", "").isalnum()

# Right — combine isascii() and isalnum()
def is_valid_slug(s: str) -> bool:
    cleaned = s.replace("-", "")
    return cleaned.isascii() and cleaned.isalnum()
```

**Rule**: When validating identifiers, slugs, filenames, or any ASCII-restricted token, ALWAYS combine `isascii() and isalnum()`. NEVER rely on `isalnum()` alone to enforce ASCII. The tests will pass on the developer's input but fail in production the first time a non-ASCII string arrives.

## JSONL stream vs single-object JSON — verify CLI output format before parsing

External CLI tools that accept a `--json` flag do not universally return a single JSON object. They may emit JSONL (one JSON object per line), SSE, or chunked envelopes. Assuming single-object format and calling `json.loads(raw)` on the full output causes silent data corruption — or worse, raw JSON being forwarded to end users.

```python
def _extract_from_jsonl(raw: str, event_type: str, item_type: str) -> str:
    messages: list[str] = []
    for line in raw.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        try:
            event = json.loads(stripped)
        except json.JSONDecodeError:
            logger.warning("Skipping non-JSON line: %s", stripped[:200])
            continue
        if not isinstance(event, dict):  # guard against JSON array lines
            continue
        if event.get("type") != event_type:
            continue
        item = event.get("item", {})
        if item.get("type") == item_type:
            text = item.get("text", "")
            if text:
                messages.append(text)
    if not messages:
        logger.warning("No %s/%s found (%d lines)", event_type, item_type, len(raw.splitlines()))
        return raw  # fallback — always log when falling back
    return "\n".join(messages)
```

**Rules**:
- ALWAYS write a unit test for the actual CLI output format before building a parser that depends on it.
- NEVER use a silent `except` fallback that returns raw output — it hides format changes until they reach end users.
- ALWAYS handle `FileNotFoundError` from `subprocess` (binary not installed).
- ALWAYS log a warning when falling back to raw output so format drift is visible.

## Config path injection — derive all paths from one injectable root

Hardcoding a config directory (e.g., `Path.home() / ".myapp"`) makes the object untestable: injecting `tmp_path` as a workspace root does not affect the credential path, so tests accidentally read the developer's real config files and pass by coincidence.

```python
@dataclass
class AppConfig:
    config_dir: Path = field(default_factory=lambda: Path.home() / ".myapp")

    @property
    def credentials_dir(self) -> Path:
        return self.config_dir / "credentials"

    @property
    def cache_dir(self) -> Path:
        return self.config_dir / "cache"
```

In tests, inject a `tmp_path`-derived `config_dir`:

```python
def test_missing_token(tmp_path: pytest.MonkeyPatch) -> None:
    cfg = AppConfig(config_dir=tmp_path / ".myapp")
    # credentials_dir is now inside tmp_path — no accidental reads from ~/.myapp
```

**Rules**:
- ALWAYS derive every path property from a single injectable root (`config_dir`, `project_root`, etc.).
- NEVER hardcode `Path.home()` or absolute paths in path-derivation properties.
- ALWAYS document the derivation chain in a docstring — implicit property relationships become invisible bugs after refactoring.
- See also: "Project-root resolution with environment-variable override" above for the env-var variant of this pattern.

## Signal handler cleanup — remove handlers in `finally` to prevent pytest leakage

`loop.add_signal_handler()` (and `signal.signal()`) modifies **process-global** state. pytest creates a new event loop per async test but does not reset signal handlers. If `daemon.run()` registers handlers and the test ends without cleanup, the handlers remain as zombies in the next test's event loop, causing infinite hangs in unrelated tests.

```python
async def run(self) -> None:
    loop = asyncio.get_running_loop()
    loop.add_signal_handler(signal.SIGTERM, self._handle_shutdown)
    loop.add_signal_handler(signal.SIGINT, self._handle_shutdown)
    try:
        async with asyncio.TaskGroup() as tg:
            tg.create_task(self._main_task())
    finally:
        loop.remove_signal_handler(signal.SIGTERM)  # always clean up
        loop.remove_signal_handler(signal.SIGINT)
```

**Rules**:
- ALWAYS pair every `add_signal_handler` with a matching `remove_signal_handler` in `finally`.
- ALWAYS treat any process-global state mutation (`signal`, `sys.path`, `os.environ`) as requiring explicit cleanup.
- NEVER test a full `daemon.run()` entry point in a pytest async test — test individual components directly to avoid cascading signal state.

## `\b` word boundary does not match across underscores in SCREAMING_SNAKE_CASE

`\b` in Python regex marks a transition between `\w` (`[a-zA-Z0-9_]`) and `\W`. Because `_` is a word character, there is no boundary between the `_` and adjacent letters in `API_KEY`. A pattern like `\b(key|token|secret)\b` will never match `API_KEY` or `DB_PASSWORD`:

```python
import re

# Wrong — misses SCREAMING_SNAKE keywords
_SECRET_RE = re.compile(r"\b(token|key|secret|password)\b", re.IGNORECASE)
print(bool(_SECRET_RE.search("API_KEY=abc")))   # False — missed

# Right — use a lookbehind/lookahead to accept underscore boundaries
_SECRET_RE = re.compile(
    r"(?<![a-zA-Z0-9])(?:token|key|secret|password)(?![a-zA-Z0-9])",
    re.IGNORECASE,
)
print(bool(_SECRET_RE.search("API_KEY=abc")))   # True
```

**Rules**:
- NEVER rely on `\b` alone to match keywords that may appear as segments of `snake_case` or `SCREAMING_SNAKE_CASE` identifiers.
- ALWAYS use a lookbehind/lookahead that treats `_` as a separator, or match the `KEY=` assignment pattern explicitly.
- When the limitation is a known trade-off and fixing it would cause false positives, document it in a code comment at the regex definition site.

## `logging.Filter` must be attached to a handler, not to the root logger

Python's logging propagation model: a `LogRecord` is created by a child logger and propagated up to parent loggers, ultimately reaching the root logger's **handlers**. Filters attached to a logger are checked when *that logger* processes the record — but propagated records skip the parent logger's filters and go directly to its handlers.

```python
# Wrong — child loggers bypass this filter via propagation
logging.getLogger().addFilter(RedactionFilter())

# Right — attach to handler so every propagated record is filtered
for handler in logging.getLogger().handlers:
    handler.addFilter(RedactionFilter())

# Or attach when creating the handler:
handler = logging.StreamHandler()
handler.addFilter(RedactionFilter())
logging.getLogger().addHandler(handler)
```

**Rules**:
- ALWAYS attach filters intended for global coverage to **handlers**, not to the root logger.
- ALWAYS add the filter to a handler immediately after creating it — not as a separate later step — so no window exists where unfiltered records can escape.
- ALWAYS add a test that emits a log line from a child logger (`logging.getLogger(__name__)`) and asserts the filter was applied.

## MagicMock attribute setup — explicit values, not auto-generated

`unittest.mock.MagicMock` auto-generates child Mock objects for any attribute access. This means `mock.status` returns a `MagicMock` that compares unequal to `200` (or any concrete value), silently breaking tests when production code starts checking new attributes:

```python
# Production adds: if resp.status != 200: raise
# Test that previously passed:
mock_resp = MagicMock()
mock_resp.read.return_value = b"{}"
# mock_resp.status is auto-Mock — not 200, not anything, just !=

# Right — set every attribute production reads
mock_resp = MagicMock()
mock_resp.status = 200
mock_resp.read.return_value = b"{}"
```

**Rule**: When production code adds an attribute or method check, audit every test that mocks the affected object and set the attribute explicitly. NEVER trust `MagicMock` auto-generation for attributes that participate in equality, comparison, or boolean tests. Auto-Mock is fine for "this method gets called once" assertions; it is unsafe for `if obj.x != Y` branches.

## `--dry-run` must guard every mutation in the call graph, not just the wrapper

A `--dry-run` flag is a read-only *promise*. If the wrapper skips its own writes but an inner helper still writes YAML, inserts DB rows, or renames files, the promise is broken — and the leak is easy to miss because the wrapper looks correct. A function named `check_*` or `list_*` can still write (e.g. caching a fetched content hash back to disk), so naming heuristics won't save you.

```python
# 1. Propagate dry_run explicitly through helper signatures (safe default False)
def check_resources(name: str, *, dry_run: bool = False) -> list[Status]:
    for item in items:
        status = fetch_and_compare(item)
        # 2. Guard at each mutation site — do NOT rely on the caller's skip
        if status == "changed" and not dry_run:
            _upsert_field(path, item.key, "content_hash", new_hash)
            path.write_text(updated)
    return statuses

# 3. The wrapper only forwards dry_run; the guards live in the helpers
def cleanup_cmd(name: str, dry_run: bool = False) -> None:
    results = check_resources(name, dry_run=dry_run)
    if not dry_run:
        mark_stale(...)

# 4. Regression test asserts file mtime + content hash are unchanged
def test_dry_run_preserves_yaml(tmp_path):
    path = tmp_path / "resource.yaml"
    before = path.stat().st_mtime_ns, hashlib.sha256(path.read_bytes()).hexdigest()
    cleanup_cmd("demo", dry_run=True)
    after = path.stat().st_mtime_ns, hashlib.sha256(path.read_bytes()).hexdigest()
    assert before == after  # mtime + content hash both unchanged
```

**Rules**:
- When adding `--dry-run`, trace the call graph recursively from the entry point and enumerate every write site (YAML/DB write, file rename) — guard each one. Do not rely on a top-level wrapper skip.
- NEVER assume read-only from a `check_*`/`list_*` name; verify the body.
- Regression tests MUST assert file mtime + content hash are unchanged, not just that a skip was logged.
