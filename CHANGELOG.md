# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Project scaffold: feature-first folder structure (`library`, `player`, `voices`, `settings`, `onboarding`, `search`)
- Core documentation: README, ARCHITECTURE.md, CONTRIBUTING.md
- ADR process established (`docs/adr/`)
- Design system tokens ported from HTML mockups into `lib/core/theme/`
- CI workflow: lint + test on every PR (`.github/workflows/ci.yml`)

### Decided
- Flutter chosen as cross-platform framework — see ADR-0002
- Feature-first project structure — see ADR-0001 note in this file's companion ADR log

---

## Version History

_No tagged releases yet. First entry will be `0.1.0` once the core screen set (Library, Player, Voices, Settings) is functional against mock data._
