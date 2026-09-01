# Changelog

All notable changes to this plugin are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Versions prior to 2.11.0 are recorded in the git history only.

## [Unreleased]

## [2.16.0] - 2026-09-01

### Changed
- Removed `maxTurns` from every read-only agent (24 `*-master` agents,
  `code-reviewer`, `reflector`). A run that hits the turn cap returns a partial
  result that the caller may consume as if it were complete; the cap bought no
  safety these agents did not already have from `permissionMode: plan`.
  `refactor-assistant` keeps `maxTurns: 20` as a runaway backstop because it is
  write-capable.
- Reallocated models: the 24 `*-master` knowledge-base agents moved from `opus`
  to `sonnet` (card retrieval and synthesis, not deep reasoning), and
  `code-reviewer` moved from `sonnet` to `opus`. The `model="opus"` override in
  the 24 domain skills' `Task(...)` invocation was aligned to `sonnet` so the
  skill no longer overrides the agent's own model.
- Removed the redundant `disallowedTools: Write, Edit` from the 24 `*-master`
  agents and `code-reviewer`. Read-only is enforced by `permissionMode: plan`,
  which is unchanged; the denylist named two tools the agents' `tools` allowlist
  already omits. (The allowlist is not itself a read-only guarantee — it
  includes `Bash`, and a shell command can write.) The Codex sync derives its
  read-only sandbox from `permissionMode == "plan"`, so the exported Codex
  agents remain `sandbox_mode = "read-only"` — verified by running the sync and
  inspecting the generated TOML: 26 of 27 carry `sandbox_mode = "read-only"`,
  the exception being the write-capable `refactor-assistant`.
- Added one operating rule to the 24 `*-master` agents: batch independent `kb`
  calls — multiple `kb show` calls and any independent searches — into ONE
  message so they run in parallel rather than one per turn. This is the
  turn-efficiency counterpart to the `maxTurns` removal above.
- Translated every agent body and `description` to English, per the
  system-prompt language norm. The agents' output language is unchanged: the
  masters keep the explicit "answer in Korean" rule and their Korean answer
  headings, and two agents gained an explicit Korean-output rule that had been
  implicit before the translation: `code-reviewer` ("write the review in
  Korean") and `reflector` ("answer in Korean" — it already emitted Korean
  report messages and Korean-keyed MISTAKES/PATTERNS record templates, which are
  left untranslated so the format written into `docs/` is unchanged).

### Fixed
- `reflector` no longer claims a capability it does not have. Its `tools` are
  `Read, Grep, Glob`, so the role bullets now say it *proposes* entries for
  `docs/MISTAKES.md` / `docs/PATTERNS.md` — the parent session applies only the
  approved ones, which is how `commands/reflect.md` already wired it. The
  size-cap logic is kept but reframed as what the agent proposes or withholds,
  and the empty-session pre-check no longer instructs actions the agent cannot
  perform — the `wc -l` became a Read-and-count, and inspecting git commits,
  hook execution, and PR state became a proposal for the parent to check.
- `claude-code-standards` skill corrections: `permissionMode` lists `auto`
  instead of the non-existent `delegate` (official values: `default`,
  `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions`, `plan`); the agent
  checklist states the new `maxTurns` policy instead of "always set it"; and the
  KB-pattern example drops `disallowedTools`, uses `sonnet`, and states that
  `permissionMode: plan` is the read-only mechanism while the `tools` allowlist
  only narrows the surface — with a caveat that a parent session in `auto` mode
  ignores a subagent's `permissionMode`, so read-only is not guaranteed by
  construction there.
- `CLAUDE.md` agent template documents `maxTurns` as an optional backstop for
  write-capable agents rather than a required field, and drops its
  `disallowedTools: Write, Edit` line — the redundancy this release removes
  from the agents themselves.

## [2.15.0] - 2026-08-26

### Added
- `kubeflow` skill and `kubeflow-master` agent — Kubeflow knowledge-base
  domain (Kubernetes-native AI/ML platform: Pipelines V2 + legacy-v1, Katib,
  Trainer, Notebooks/Workspaces, Hub/Model Registry, Central Dashboard,
  Spark Operator, SDK, MCP Server, KCD release lineage, ecosystem), 206 KB
  cards (Principle 18 / Pattern 50 / Fact 138), following the hermes-agent
  pattern. (#85)

## [2.14.0] - 2026-06-23

### Added
- `hermes-agent` skill and `hermes-agent-master` agent — Hermes Agent
  knowledge-base domain (Nous Research Hermes Agent platform), following the
  deepagents pattern (#80).

### Fixed
- Bumped version from 2.13.0 (the hermes-agent registration in #80 added
  components without a version bump, so `claude plugin update` reported
  "already at latest" and never re-extracted the component cache).
- Synced stale component counts across docs: `CLAUDE.md` (skills 35→37,
  agents 24→26), `docs/architecture.md` (skills 33→37).
- Registered previously-missing components in `references/components.md`:
  `terraform`, `mlx-swift`, `mlx-c` skills and `mlx-swift-master`,
  `mlx-c-master` agents.

## [2.13.0] - 2026-05-17

### Added
- `terraform` skill and `terraform-master` agent (#78).

## [2.12.2] - 2026-05-08

### Changed
- Harvested 2 universal mistakes into common-pitfalls (#75).

## [2.12.1] - 2026-05-08

### Changed
- Harvested universal patterns from knowledge-base PATTERNS.md (#74).

## [2.12.0] - 2026-05-02

### Added
- `mlx-swift` and `mlx-c` skills + agents (#73).

## [2.11.0] - 2026-04-30

### Added
- `mlx` skill and `mlx-master` agent (#70).
