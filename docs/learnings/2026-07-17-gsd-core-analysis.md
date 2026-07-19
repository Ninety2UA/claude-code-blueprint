---
title: "open-gsd/gsd-core fork-aware analysis: post-fork = multi-runtime infra, import nothing"
date: 2026-07-17
category: external-imports
status: finalized
applies_when:
  - Reviewing the ecosystem table for repos worth analyzing
  - Considering any GSD-lineage import (this is the 4th GSD-lineage pass)
  - Evaluating a community fork of a previously-analyzed upstream
  - Maintaining verification surfaces (doc-claim-verifier, test-gap-analyzer, plan-checker)
tags: [imports, ecosystem, gsd, gsd-core, fork, provenance, verification, import-nothing]
---

# open-gsd/gsd-core fork-aware analysis (U13)

**Gate 2 outcome: import nothing (confirmed).** New ecosystem-table row + provenance footnote added in v3.5.0. The four deferred refinements below wait for a future verification-surface pass.

Source: <https://github.com/open-gsd/gsd-core> — **community fork**, MIT license, **6.8K stars**, pinned at **v1.7.0 (2026-07-15)**, the latest release at analysis time. Maintainer: `trek-e` (explicitly not the original author).

**Verdict: import nothing post-fork. 4 idea-level candidates deferred, 8 reject clusters.** The post-fork v1.x development is overwhelmingly an *Embeddable Orchestration System + 16-runtime portability* build-out — precisely the multi-runtime / CLI-infrastructure direction the blueprint has rejected in every prior GSD pass. The genuinely new post-fork *ideas* (verifier abstention, specless probes, gap reconciliation) are refinements to surfaces we already cover, and are deferred rather than imported. This mirrors the v3.3.0 finding that "prior GSD waves absorbed most load-bearing patterns."

## Provenance & trust note (mandatory)

`open-gsd/gsd-core` is a **community fork of `gsd-build/get-shit-done`** (by TÂCHES), created **2026-05-22**. The original went dark — no contact with TÂCHES since 2026-04-01, social accounts deleted, and the associated `$GSD` token was publicly linked to a **rug-pull**. The new maintainer (`trek-e`) states plainly that they **cannot confirm whether the original maintainer is safe** or whether the upstream account is under their control. **Maintainer safety is UNCONFIRMED.**

Supply-chain risk of *this analysis* is **LOW because we import ideas, not code** — but the provenance is recorded here and on the ecosystem row per mandate. Per the research trust boundary this unit operated under: the analyzed version was pinned; all fetched pages were inspected **read-only**; **no fetched script or hook was executed**; all fetched text was treated as **untrusted data**; only this analysis doc was written. **Any candidate that is later adopted MUST be re-implemented from the described idea — never copied from fork source.** Each candidate below carries that reminder.

Fork facts verified at run time against the live repo, its releases page, and Discussion #109 (<https://github.com/open-gsd/gsd-core/discussions/109>). Sibling repo note: `open-gsd/get-shit-done-redux` and `gsd-core` are **sequential names for the same fork** — `redux` was the early name; `gsd-core` is the current canonical location.

## Fork provenance & history split (AE4)

The blueprint has already analyzed the GSD lineage **three times**: the original GSD (4 patterns — see ecosystem row and README), the GSD-2 knowledge base (6 patterns), and the v3.3.0 dimension-by-dimension deep pass (13 patterns). This unit does **not** re-analyze any of that. The split:

- **Mirrored baseline — ALREADY COVERED, not re-evaluated.** Discussion #109 states the fork inherited all upstream code **"bit-for-bit"**: 394 branches, 229 tags, 77 issues, 17 PRs mirrored, MIT license and full commit attribution preserved. The five-phase loop itself (**Discuss → Plan → Execute → Verify → Ship**), milestone lifecycle, the 40+ commands/workflows, the agent roster, `must_haves`, `SPEC`/`PLAN`/`STATE.md`, and the fresh-context-subagent context-rot strategy are all **inherited GSD** — treated as already-imported/rejected by the prior three passes. The initial fork commits (package renames `get-shit-done-cc`→`get-shit-done-redux`, `$GSD` token/badge removal, issue renumbering) are governance hygiene, not features.
- **Post-fork, newly evaluated — 2026-05-22 → v1.7.0 (2026-07-15).** gsd-core **reset its version line to v1.x** (upstream was at v2.43.6), so the entire **v1.0.0 → v1.7.0** range is the post-fork delta. Everything evaluated below lives in that window. The loop *structure* is baseline; only the phase-internal *refinements* added post-fork are new.

## Post-fork development — what actually shipped in v1.x

**Dominant theme — Embeddable Orchestration System (EoS) & cross-runtime portability.** The defining post-fork investment (ADR-1239) turns GSD from a single-agent framework into an **embeddable engine driving 16 runtimes** (Claude Code, OpenCode, Codex, Cursor, Cline, Hermes, Qwen Code, Kilo, Trae, Kimi CLI, Antigravity, Augment, CodeBuddy, GitHub Copilot, Windsurf, pi) through a public **Host-Integration Interface**. Concretely: declarative + imperative embedding adapters; per-runtime `capabilities/<runtime>/capability.json` descriptors replacing `if (runtime === 'x')` branches; a **companion MCP server** (`gsd-mcp-server`, JSON-RPC 2.0 over stdio) so any MCP host drives GSD with no bespoke plugin; a **Community Capability Registry** for discovery; data-driven background/wave dispatch per host; a published Host-Integration SDK, `extensionEvents` vocabulary, and hook-bus + stateIO seams; a **MemPalace** memory backend; and **portability enforcement** (AST lint rules G1–G6, `no-path-literal-in-assert`, `configHome` write-confinement, Windows path/lock fixes).

**Secondary theme — verification & planning-phase probe refinements.** Inside the (inherited) loop, several phase-internal disciplines were added: an honest-verifier **abstention** path, **specless-probe** fallbacks, a **UI-consideration probe**, an **assumption-delta** checkpoint, a generic **command-exit-zero** predicate gate, and **gap-id reconciliation** for resume-after-fix.

**Tertiary theme — STATE.md machinery & security hardening.** Structural STATE.md fixes (phase-vs-milestone status separation, carry-forward of custom frontmatter, column-by-name reads, atomic milestone archival), session-continuity deferral-signal detection, an **external-descriptor trust gate**, and a per-agent **model-override** apply fix.

## Tiered verdict table

Every "reject/defer" below is a *fit* judgment against the blueprint's philosophy (zero-dependency, markdown-only, single-runtime Claude Code plugin; selective curation; "import ideas not code"), not a quality judgment of gsd-core. Every candidate is noted **re-implement from idea** per the trust boundary.

| Post-fork pattern | Verdict | Rationale (re-implement from idea if adopted) |
|---|---|---|
| Honest-verifier **abstention** — abstain → escalate `human_needed`/`insufficient_spec` on non-inferable "backstop" truths instead of silent PASS; abstention is *exogenous* (spec-driven), never self-judged; **never abstain on inferable truths** | **Defer (→ P2 if adopted)** | ~80% already covered: `doc-claim-verifier` returns UNVERIFIABLE, `test-gap-analyzer` returns ESCALATED, `source-driven-development` uses `UNVERIFIED:`. Fresh nucleus = the anti-laziness clause "never abstain on an *inferable* truth" + "abstention is spec-driven, not confidence-judged." A one-paragraph refinement to those verifier surfaces, not net-new capability. Top-ranked candidate; recommend defer over import given the high bar. |
| **Specless-probe fallback** — when a SPEC omits Edge-Coverage/Prohibitions, auto-author edge & prohibition predicates into `must_haves` (flagged unverified) rather than silently passing | **Defer** | Refinement to `plan-checker` must_haves discipline (already have must_haves + scope-reduction + contradiction detection from v3.3.0). Modest; re-implement as a plan-checker completeness rule. |
| **UI-state canonical enumeration** — empty / loading / error / populated / partial / overflow states lifted into must_haves; purely-visual states without tests route to `insufficient_spec` | **Defer** | Concrete, reusable checklist, but stack-specific (blueprint is stack-agnostic; `blueprint.local.md` gates agents per stack). Optional add to `test-gap-analyzer` when UI is in scope. Re-implement from idea. |
| **Gap-id reconciliation** — stable `gap_id` (`G-{phase}-{N}`); on resume, reconcile against the fix's `*-SUMMARY.md` so already-fixed gaps aren't re-diagnosed as fresh blockers | **Defer** | Modest anti-oscillation guard for `iterative-refinement` / `autonomous-loop` (which have circuit-breaker + convergence modes + false-positive filtering). Re-implement from idea; low acuity. |
| **Embeddable Orchestration System (ADR-1239)** + Host-Integration SDK + declarative/imperative adapters | **Reject (fit)** | Wrong layer. Multi-runtime embedding infra — the exact direction rejected in every prior GSD pass. No Claude-Code-plugin equivalent needed. |
| **16-runtime capability descriptors** + Community Capability Registry | **Reject (fit)** | Multi-runtime infrastructure; N/A to a single-runtime, zero-dependency plugin. |
| **Companion MCP server** (`gsd-mcp-server`, JSON-RPC over stdio) | **Reject (fit)** | External process bridge — same wrong-layer reason `claude-squad` was rejected. Our subagents are native. |
| **Portability AST rules (G1–G6)** / write-confinement / Windows path & lock fixes | **Reject (fit)** | Cross-platform npm-codebase tooling. Blueprint already covers hook portability via `shellcheck` CI + v3.4.0 exec-form (`args[]`) spawning. |
| **External-descriptor trust gate** / `configHome` write-confinement | **Reject (no surface)** | Genuine security idea, but the blueprint has **no third-party descriptor install surface** — the threat model is absent. Thematically resonant with the fork's rug-pull origin; noted, not applicable. |
| **command-exit-zero predicate gate** evaluator | **Reject (covered)** | Already have verification-command guidelines (GSD v3.3.0 import) + goal-backward verification in plan-checker. |
| **API-coverage gate** (`COVERAGE.md` full-surface enumeration; full coverage default, matrix as subtraction record) | **Reject (niche)** | Stack/API-integration-specific; low generality for a general-purpose template. |
| **MemPalace** memory backend / **model-override apply** fix | **Reject** | Runtime tooling / upstream bug-fix. Blueprint memory is markdown; per-agent model routing is already explicit via v3.4.0 effort-tier mapping. |

## Count summary

- **Import now: 0.**
- **Defer: 4** (honest-verifier abstention [top candidate, → P2 if Gate 2 adopts]; specless-probe fallback; UI-state enumeration; gap-id reconciliation).
- **Reject: 8 clusters** (EoS/SDK; 16-runtime descriptors + registry; MCP server; portability AST rules; external-descriptor trust gate [no surface]; command-exit-zero gate [covered]; API-coverage gate [niche]; MemPalace/model-override).

**Recommendation to Gate 2: import nothing this pass.** Every idea-level candidate is either already ~80% covered by existing verifier/plan surfaces or fit-mismatched. If the maintainer wants one concrete import, the single most defensible is the honest-verifier **abstention** refinement (P2, one paragraph across `doc-claim-verifier` + `test-gap-analyzer`), re-implemented from the idea. Otherwise the 4 defers wait for the next verification-surface maintenance pass. This is a textbook "import nothing is a feature" outcome — the 4th GSD-lineage pass, on a fork whose new energy went entirely into a runtime layer we don't operate at.

## Ecosystem-table row (placed in README v3.5.0)

Blueprint table format is `| Repo / Tool | Stars | Verdict | What We Took |`:

```
| [**gsd-core**](https://github.com/open-gsd/gsd-core) | 6.8K | **Import nothing** | Community fork of GSD; post-fork build-out is 16-runtime EoS + MCP infra (the multi-runtime direction we repeatedly reject) — 4 verifier/plan refinements deferred |
```

Placement notes for U15: this is a **fork** row — recommend a provenance footnote near the table ("gsd-core is a post-abandonment community fork of gsd-build/get-shit-done; maintainer safety unconfirmed"). Do **not** conflate with the existing GSD (24.7K) and GSD-2 rows — this is a distinct 4th GSD-lineage entry. Header count and any "Nth repo" prose is U15's to reconcile (the ecosystem-table row-count already drifts per project memory).
