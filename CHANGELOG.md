# Changelog

All notable changes to this plugin are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> Versions prior to 2.11.0 are recorded in the git history only.

## [Unreleased]

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
