---
title: "obra/superpowers delta analysis (baseline → v6.1.1): import nothing, establish first version pin"
date: 2026-07-17
category: external-imports
cycle: platform-sync-2026-07-17
status: finalized
requirement: U12
applies_when:
  - A future platform-sync cycle re-analyzes obra/superpowers (start from the v6.1.1 pin below)
  - Reconsidering whether the blueprint should support non-Claude-Code harnesses
  - Someone proposes collapsing the two-stage per-task review in subagent-driven-development
  - Refreshing the README ecosystem row for Superpowers (star count is badly stale)
tags: [imports, ecosystem, superpowers, version-pin, harness-portability, review-architecture]
---

# obra/superpowers delta analysis — baseline → v6.1.1

Source: <https://github.com/obra/superpowers> (MIT). Analyzed 2026-07-17 as unit U12 of the platform-sync cycle. **Gate 2 outcome: import nothing (confirmed).** First version pin established: v6.1.1. Leftover superpowers branding in four blueprint skills was cleaned up in v3.5.0.

## Version pin

**First recorded pin: v6.1.1 (2026-07-02).** This is the current latest release (release history verified: v6.1.1 → v6.1.0 → v6.0.3 → v6.0.2 → v6.0.0 → v5.1.0 → v5.0.x). The blueprint's README ecosystem row records Superpowers with "Patterns adopted: Anti-rationalization guards, TDD quality gates" but **carried no version pin** — so the baseline for this delta is *the recorded imports*, not a version bound. Everything below reconciles from those recorded imports forward to v6.1.1.

## Verdict counts

- **Imported: 0**
- **Deferred: 1** (P3 — AI-agent contributor guidelines)
- **Rejected / already-have / not-applicable: 9 patterns**
- **Housekeeping flagged for Gate 2 implementation: 2** (star-count refresh; de-brand derived skills)

**This is a documented "import nothing" outcome.** It is not a thin result — the value of the unit is the reconciliation below, which shows the blueprint already absorbed essentially all of superpowers' transferable methodology, and superpowers' recent work has moved into territory the blueprint deliberately excludes (multi-harness portability) or deliberately does differently (multi-agent review).

## Baseline reconciliation — the README understates what was taken

The recorded import ("anti-rationalization guards, TDD quality gates") is a large understatement. A skill-vocabulary comparison shows the blueprint already carries **13 of superpowers' 14 current skills by the same name**:

| superpowers skill (v6.1.1) | in blueprint? |
|---|---|
| brainstorming | yes |
| dispatching-parallel-agents | yes |
| executing-plans | yes |
| finishing-a-development-branch | yes |
| receiving-code-review | yes |
| requesting-code-review | yes |
| subagent-driven-development | yes |
| systematic-debugging | yes |
| test-driven-development | yes |
| using-git-worktrees | yes |
| verification-before-completion | yes |
| writing-plans | yes |
| writing-skills | yes |
| using-superpowers (brand bootstrap) | no — blueprint has its own SessionStart hook + CLAUDE.md bootstrap |

The blueprint is effectively a **superset fork** of superpowers' skill methodology, extended with orchestration (waves, agent-teams, ship-loop, review-swarm), a 10-handler hook layer, and 29 agents that superpowers does not have. Consequence for this delta: **since the baseline, superpowers has not shipped a single new transferable skill the blueprint lacks.** Every current superpowers skill has a blueprint counterpart. All the deltas are internal refactors of skills we already own.

## Tiered verdict table

| Pattern (superpowers release) | Verdict | Rationale |
|---|---|---|
| Multi-harness portability — Codex, Cursor, Kimi, Pi, Antigravity, Copilot CLI, OpenCode (v5.0.7, v6.0.0, v6.1.0, v6.1.1) | **Reject** | Blueprint is a Claude-Code-native plugin template by identity; supporting 8 foreign harnesses is a different product. Out of scope, against "internal over external." |
| Token-cost trimming — compress bootstrap + trim reference docs (v6.1.0) | **Reject (already-have)** | `session-start.js` already emits only one-line existence reminders; skills use progressive disclosure (SKILL.md on demand). Bootstrap is already minimal. |
| SDD scratch relocation `.git/` → `.superpowers/sdd/` (v6.0.3) | **Reject (not applicable)** | Verified: blueprint writes zero scratch into `.git/`. Plans live in `docs/plans/`, sdd-cache in `.claude/sdd-cache` (gitignored), worktrees are native. The bug-class does not exist here. |
| Eval-harness split to its own repo (v6.0.2) | **Reject (not applicable)** | Blueprint ships no eval-harness submodule; testing guidance is inline docs (`testing-skills-with-subagents`). No submodule pain to solve. |
| Reviewer consolidation — 2 per-task reviewers → 1 + inline self-review checklist (v5.0.4, v5.0.6, v6.0.0) | **Reject (divergence recorded)** | Superpowers found the two-reviewer loop cost ~25 min/task and simplified away from it. The blueprint deliberately keeps two-stage review AND already offers cheaper tiers (`quick-fix` = no review; `verification-before-completion` = inline self-review). We already span the spectrum they collapsed. See "Divergence" below. |
| Worktree detection → prefer native harness controls (v5.1.0) | **Reject (already-have)** | Orchestration already uses native `isolation: worktree` (team-lead, wave-orchestration, per Part 1). The `using-git-worktrees` skill remains as a portable manual fallback. |
| Brainstorming visual companion — Node server + auth/security hardening (v6.0.0, v5.0.5) | **Reject** | A stateful Node server with its own auth, Node-22 and Windows-PID operational burden. Against "no heavy external runtime deps"; blueprint brainstorming is pure-skill. |
| Deterministic packaging script for Codex plugins (v6.1.1) | **Reject** | Harness-specific packaging plumbing; blueprint distributes via `install.sh` + marketplace + `/plugin install`. |
| Removed deprecated slash commands / legacy named agents (v5.1.0) | **Reject** | Their internal housekeeping, not a pattern. |
| AI-agent contributor guidelines (v5.1.0 — guidelines targeting AI agents submitting PRs) | **Defer (P3)** | Genuinely additive and on-theme (blueprint is about AI-assisted dev), but a small doc polish, not a capability. Bookmark for a `CONTRIBUTING.md` refresh. |

## Divergence worth recording — superpowers is simplifying away from multi-agent review

The most interesting signal in the delta is a **philosophy divergence that validates the blueprint's design**. Across v5.0.4 → v5.0.6 → v6.0.0, superpowers progressively removed the exact machinery the blueprint's `subagent-driven-development` retains: it consolidated two whole-plan reviewers to one, then *replaced subagent review loops with inline self-review checklists* (citing ~25 min of execution overhead), then consolidated two per-task reviewers into one.

This is a respected, ~250K-star repo concluding that heavy per-task multi-agent review is not worth its cost for their default flow. It is a useful external data point — but it is **not an import**, because the blueprint already offers the full cost/rigor spectrum superpowers collapsed to a single point:

- `quick-fix` — no review (their lightweight end)
- `verification-before-completion` — inline self-review checklist, required per task (their new default)
- `subagent-driven-development` — implementer self-review + spec reviewer + code-quality reviewer + final reviewer (the thorough end the blueprint keeps on purpose)

Recorded so a future cycle does not read superpowers' consolidation as pressure to strip the blueprint's review tiers. If the two-stage loop is too heavy for a given task, the answer is *choose a cheaper tier we already ship*, not remove the tier.

## Housekeeping surfaced for Gate 2 implementation

Two pre-existing items the delta exposed (neither is an import from the delta; both are cheap fixes to bundle when the ecosystem row is touched):

1. **Star count is badly stale.** README records **71K**; current is **~252K** (star-history: 252.1K, rank #14 globally; obra profile ~256K). Refresh the ecosystem row and add the `v6.1.1` pin at implementation. Pull the exact figure fresh at that time.
2. **Derived skills still carry superpowers-brand strings.** `using-git-worktrees`, `verification-before-completion`, and `subagent-driven-development` still contain `~/.config/superpowers/…` paths, "Jesse's rule", "24 failure memories", and a `~/.config/superpowers/hooks/` example. Harmless but off-brand for a standalone template. Optional de-brand pass — not delta-driven, flagged because the analysis walked these files.

## Bottom line

Establish the **v6.1.1** pin, refresh the stale star count, and import nothing. Superpowers remains a valuable methodology sibling, but its transferable skill set was already fully absorbed before this cycle, and its recent trajectory (cross-harness portability, a brainstorm server, review simplification) is either out of the blueprint's scope or a direction the blueprint has deliberately not taken. The one genuinely additive idea — AI-agent contributor guidelines — is deferred as a low-priority doc polish.
