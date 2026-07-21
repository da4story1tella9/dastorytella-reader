# ADR-0001: Record architecture decisions as ADRs

**Status:** Accepted
**Date:** 2026-07-19

## Context

Technical decisions made early in a solo project are easy to forget the reasoning behind, especially once implementation work (via Claude Code or otherwise) picks up pace. Without a record, decisions either get silently re-litigated or blindly assumed to still be correct.

## Decision

Every structurally significant decision (state management, major dependency, data model shape, provider choice) gets recorded as a numbered ADR in `docs/adr/`, using `docs/adr/template.md`.

## Alternatives Considered

- **No formal record, rely on memory/commit messages** — rejected; commit messages capture *what* changed, not *why*, and memory fades.
- **Record decisions only in ARCHITECTURE.md** — rejected as the sole method; ARCHITECTURE.md describes current state well but gets rewritten over time, losing the historical reasoning trail. ADRs are immutable once accepted.

## Consequences

Slightly more overhead per major decision (a few minutes to write it down). In exchange, the project remains legible to a future collaborator — or a future version of the project owner — without re-deriving reasoning from scratch.
