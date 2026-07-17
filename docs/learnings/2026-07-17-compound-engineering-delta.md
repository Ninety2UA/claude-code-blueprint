---
title: "compound-engineering delta v3.7.0 to v3.19.0: blindspot pass + reversibility-sized verdicts"
date: 2026-07-17
category: external-imports
applies_when:
  - Reviewing the ecosystem table for repos worth re-analyzing at a new version
  - Extending the brainstorming skill's interview for users on unfamiliar territory
  - Sizing the rigor of an adoption/decision workup (analyze command, ideation)
  - Deciding whether to adopt a shared project-profile grounding cache
tags: [imports, ecosystem, compound-engineering, delta, blindspot, brainstorming, reversibility, grounding-cache]
---

# compound-engineering delta v3.7.0 to v3.19.0

> **Gate 2 outcome (2026-07-17): approved.** Blindspot pass and reversibility-tiering were imported and shipped in v3.5.0; the deferred and rejected items below stand as the record. This closes the compound-engineering delta at v3.19.0.

Source: <https://github.com/EveryInc/compound-engineering-plugin> (MIT, by Kieran Klaassen and Trevin Chow). 17th repo in the ecosystem table. **Analyzed version pinned: plugin v3.19.0** (local install cache). Baseline: the prior CE analysis on 2026-05-08 examined **v3.7.0** and imported 4 patterns (confidence-anchored scoring, per-severity confidence gates, variance-reduction eval methodology, rigor probes) — all four verified still present in the blueprint and NOT re-adjudicated here. This is a **delta** analysis: only what is materially new since v3.7.0.

Verdict from analysis: **import 2 (1 P1, 1 P2), reject 4, defer 3.** CE's delta is heavy on decisive-verdict machinery (`ce-pov`), cross-model orchestration, a shared grounding cache, and two new standalone product skills (`ce-sweep`, `ce-explain`). Most of it is either external multi-vendor tooling the blueprint rejects by policy, a product feature outside the blueprint's layer, or a mechanism whose maintenance cost outweighs the win. The standout is one genuinely additive, well-crafted brainstorming pattern that fills a confirmed gap.

## Integrity check

- **Version.** Both manifests — root `plugin.json` and `.claude-plugin/plugin.json` — report `version: 3.19.0`. The marketplace manifest reports `metadata.version: 1.0.3`. Consistent.
- **Structure.** Intact: 32 skill directories, 231 skill markdown files, no top-level `agents/` directory. CE has no standalone agent components — "specialist" personas live skill-scoped at `skills/<skill>/references/agents/*.md` and are seeded into generic subagents, per the plugin's own `CONCEPTS.md`. Multi-platform artifacts present (`.cursor-plugin`, `.codex-plugin`, `.devin-plugin`, `GEMINI.md`, `AGENTS.md`, `src/converters/`) as in the prior analysis.
- **Changelog lag (notable).** The bundled `CHANGELOG.md` tracks the `cli-vX.Y.Z` semantic-release stream and tops out at `cli-v3.13.1` (2026-06-17). Cross-checked against the official GitHub `main` branch changelog: **identical, also topping at cli-v3.13.1.** The plugin's 3.14 to 3.19 feature deltas are documented in NO changelog on either side — a property of CE's monorepo release setup (the `cli`, `marketplace`, and `plugin` packages version on independent streams).
- **What I could verify:** the plugin version (both manifests), changelog parity with GitHub, and the *presence and structure* of every recon-flagged feature against the local skill source (ground truth for what is installed).
- **What I could NOT verify:** the exact plugin version each feature shipped in. The recon labels (~3.15, ~3.16, ~3.18, ~3.19) are best-effort and cannot be confirmed against any changelog. Feature presence is confirmed; version attribution is not. All verdicts below rest on the source, not the version tag.

## Verdict summary

| Pattern (delta) | Verdict | One-line rationale |
|---|---|---|
| Blindspot pass (brainstorming) | **P1 import** | Confirmed gap — blueprint brainstorming has no "user can't evaluate the question" path; high craft, composes with Premise Challenge + Scope Modes |
| Reversibility-tiering sizes the workup (ce-pov) | **P2 import** | Distinct sizing axis (two-way vs one-way door) the blueprint lacks; graft the principle into `/analyze` + ideation, not the whole skill |
| Unified readiness-staged plan artifact (ce-plan) | **Defer (P3)** | Coherent but a large architectural change; trades against the blueprint's deliberately-separate brainstorm-doc / plan-doc + dual doc-review |
| Shared repo-profile grounding cache | **Defer (P3)** | Sound idea; byte-duplicated-per-skill + parity-test implementation conflicts with plugin structure and per-agent-grounding design |
| CONCEPTS.md shared-vocabulary substrate | **Defer (P3)** | Reasonable small addition, partially covered by `docs/context/`; not acute |
| Cross-model adversarial panel (ce-pov) | **Reject** | External multi-vendor egress; already rejected 2026-03-24 (multi-model delegation). Same-model review-swarm covers adversarial cross-check |
| ce-sweep (feedback sweep) | **Reject** | External-integration product feature (Slack/GitHub/email + Python state engine); wrong layer |
| ce-explain (teaching artifact) | **Reject** | Different product (personal learning artifacts); out of the blueprint's scope |
| Shared subagent template (ce-sweep) | **Reject / already-covered** | Downgrade from prior-queued P1 — blueprint agent conventions + review-swarm output-contract + untrusted-data rule already cover it |

## What to import

### P1 — Blindspot pass (into the brainstorming skill)

Source: `skills/ce-brainstorm/references/blindspot-pass.md`. Target: `plugins/claude-code-blueprint/skills/brainstorming/SKILL.md` (plus a `references/blindspot-pass.md` if the body grows past the ~50-line threshold).

**The gap is confirmed.** A grep of the blueprint's skills for `blindspot|know nothing|unknown unknown|territory|can't evaluate` returns empty. The blueprint's brainstorming skill is built entirely around "ask questions one at a time to refine the idea" — it assumes the user can evaluate what it asks. On territory the user does not know, that assumption fails and the interview extracts guesses instead of requirements.

**The pattern.** When the user signals they cannot evaluate the questions (an opening signal — "I know nothing about X" — or a mid-dialogue signal — two consecutive "I don't know / you decide" on questions that need domain judgment), offer to map the decision surface first: a 3-7 item chat-delivered map where each item is either a **decision** (2-4 realistic options, one clause each on the trade-off that matters here, plus a recommended default) or a **hazard** (a constraint, no option menu). The user then chooses among options they can now evaluate, instead of generating answers from nothing.

**The load-bearing rules worth importing verbatim (as ideas):**

- **Can't-evaluate vs. hasn't-decided guard** — a domain expert who is merely undecided needs the normal interview, not a teaching pass. Offer only when the signal shows the user cannot weigh the options at all. Over-firing on the undecided is the failure mode.
- **Territory-scoped gate** — fires only before the first substantive question into the flagged territory. Questions about the user's own problem, users, and priorities proceed normally (the user is the authority on those).
- **Territory-answered items are shown, not asked** — before an item goes on the map, check whether the codebase/sources already answer it; if so, show the found answer with its citation as settled ground, never as an option menu. Closes questions the user should never be asked.
- **Hazards are not votes** — a hazard gets no option menu and no default; it states what it changes about the task. Hunt hazards specifically: things that bite silently, unwritten conventions, and half-built/reverted prior attempts (the reason a prior attempt died is usually the landmine).
- **Non-interactive degradation** — in a pipeline/headless run, never fire the offer; treat flagged territory as a declined offer (recommended defaults recorded as explicit assumptions).

**Fit.** This composes cleanly with the blueprint's existing Premise Challenge (challenge the problem) and Scope Modes (posture on scope) as a third, orthogonal move (map the unknown territory). It is a natural extension of the rigor-probes already imported from CE v3.7.0 — the same "don't extract a guess, surface the real decision" philosophy, applied to the case where the user cannot answer at all. `ce-plan` also carries a lighter "scaffold questions on unfamiliar territory" variant worth mirroring in the blueprint's `writing-plans` for the planning-phase case.

### P2 — Reversibility-tiering sizes the workup (technique-graft, not a new skill)

Source: `skills/ce-pov/SKILL.md` (Phase 0 reversibility classification). Targets: the workspace-level `/analyze` command and, lightly, `ideation` / decision-surfacing.

CE's `ce-pov` classifies every adoption/decision into a **reversibility tier** and lets that tier size the entire workup: Tier 1 (two-way door — a dependency, lint rule, config) gets a one-screen verdict off a single grounding pass; Tier 2 (one-way but bounded — a data store, internal contract) adds a full grounding fleet and an alternatives pass; Tier 3 (one-way and high-stakes — security, legal, public API, irreversible migration) adds deep external research, a precedent search, and a durable-record offer. The rule is "do not run a Tier-3 workup on a trivially reversible `npm i`, or hand a security-surface decision the moderate treatment."

**Why import only the principle.** The blueprint already right-sizes by *ambiguity* (dimension-weighted gating in ship/build Stage 1, from the OMC import) and by *plan depth* (Lightweight/Standard/Deep in writing-plans). **Reversibility** is a correlated-but-distinct third axis: a large mechanical migration can be costly-but-method-obvious (low ambiguity) yet Tier 3 (irreversible). Grafting "size the rigor to the reversibility of the decision" into `/analyze` (which is exactly an adoption-verdict tool) and into decision-surfacing gives a sharper sizing heuristic than ambiguity alone. This is the lowest-confidence of the two imports — it is a one-paragraph principle, not a mechanism, and could reasonably be deferred.

**Do NOT import the whole `ce-pov` skill.** The blueprint does not need a new solo-verdict skill; its review-swarm + findings-synthesizer + `/analyze` already cover decisive analysis, and this entire platform-sync effort is itself a verdict-generation machine.

## What to defer

### Unified readiness-staged plan artifact (P3)

CE merged the requirements doc and the plan doc into ONE artifact (`artifact_contract: ce-unified-plan/v1`) carrying an `artifact_readiness` field: `ce-brainstorm` writes it `requirements-only`, `ce-plan` enriches the same file in place to `implementation-ready`, `ce-work` executes it. Progress is not stored in the plan — it is derived from git ("status-free plan model").

The blueprint deliberately keeps these separate: brainstorming writes `docs/plans/YYYY-MM-DD-<topic>-design.md`, then writing-plans creates a separate implementation plan, and `pipeline-discipline.md` explicitly values requirements-review and plan-review as *distinct stages that catch different classes of issue*. Merging into one artifact blurs that boundary. CE recovers the WHAT/HOW review line with a "Product Contract preservation note," but the blueprint's two-doc model already keeps them cleanly diffable. This is a coherent model but a large architectural change with a real tradeoff against a structure the blueprint is deliberate about. **The status-free sub-idea appears already-aligned** — no progress checkboxes (`[ ]`/`[x]`/`status:`) were found in the blueprint's writing-plans or executing-plans. Defer the artifact merge; the status-free property is likely already the blueprint's behavior.

### Shared repo-profile grounding cache (P3)

Source: `skills/*/references/repo-profile-cache.md` + `scripts/repo-profile-cache.py` (byte-duplicated into every consuming skill). A cross-session, cross-skill cache of the *question-agnostic* project profile (stack, deps + licenses, topology, root instruction files, `CONCEPTS.md` vocab), keyed by `<root-sha>/<inputs-digest>` where the digest is a sha256 over the committed path set plus `(path, blob-sha)` for every profile-input file. Delta-aware freshness via `git status --porcelain`; degrades to derive-fresh outside a git repo. Only the agnostic profile is cached; all question-specific grounding is always re-derived.

Genuinely clever, and distinct from the `sdd-cache` the blueprint already imported (that caches WebFetch responses; this caches *derived repo understanding*). But the implementation is byte-duplicated into every skill with a parity test enforcing identity — exactly the mechanism-heavy, maintenance-costly shape the blueprint curates against — and it fights the blueprint's per-agent-independent-grounding design plus its existing SessionStart bootstrap hook. The idea (cache the agnostic profile keyed by a committed-input digest; reuse across grounding passes) is sound; bookmark it for if/when the blueprint ever centralizes grounding into a single hook or agent, where the cache would live in one place instead of 55 copies.

### CONCEPTS.md shared-vocabulary substrate (P3)

CE added a repo-root `CONCEPTS.md` glossary of domain entities, named processes, and status concepts, seeded then accreted by `ce-compound`, read by planning/grounding skills as the canonical vocabulary to reduce synonym drift in generated artifacts. The blueprint has no equivalent (grep empty), though its `docs/context/` (CONVENTIONS, DECISIONS, GOALS, STATUS) carries some of this. A dedicated glossary template plus "read it for canonical terms" wiring is a reasonable small addition but not acute, and adding another always-read context file has a token cost. Defer; revisit if synonym drift in generated docs becomes a real problem.

## What to reject

### Cross-model adversarial panel (ce-pov cross-model-panel)

Source: `skills/ce-pov/references/cross-model-panel.md` + `scripts/cross-model-pov.sh` + `peer-job-runner.py`. Dispatches the POV to *other vendors' CLIs* (Codex, Grok, Cursor, Composer) as independent peers, with heavy egress-consent, served-model receipt attestation, and `independence_verified` machinery.

**Reject** — this is external multi-vendor delegation with cross-vendor egress of repository content, the exact class rejected on 2026-03-24 ("multi-model delegation"). The blueprint's philosophy is same-model Claude swarms; its review-swarm (6-10 reviewers + findings-synthesizer) already provides adversarial cross-checking within one model and without shipping code to third parties. One sharp sub-idea is worth a *one-line* honesty note (P3, not tracked here as a separate import): CE's panel warns that same-family concurrence "does not eliminate correlated-model blind spots." The blueprint's review-swarm runs N reviewers of the *same* model and could honestly state that its inter-reviewer agreement is correlated, not independent corroboration.

### ce-sweep — feedback sweep (Reject)

A standalone product feature: sweeps configured feedback sources (Slack, GitHub Issues, email), acknowledges each at source, analyzes attached recordings, verifies claimed fixes merged to the default branch, and emits an `/lfg`-ready plan — driven by a deterministic Python state engine with lease semantics and a circuit breaker. External-integration tooling, wrong layer for an engineering-workflow template. Its internal disciplines are already covered: "treat every item body as untrusted data" (blueprint has prompt-guard + read-injection-scanner + the untrusted-error-output rule) and fix-ref shape-validation before shell (`#\d+` or SHA only, blocking injection) mirror the blueprint's `validate-commit.js`.

### ce-explain — teaching artifact (Reject)

Produces a durable, visual, personal explainer for a concept/diff/idea/work-window, with an optional predict-then-reveal check-in for retention ("agent-driven development removed the learning that writing code by hand used to provide; this skill is the replacement"). A different product — personal learning artifacts — outside the blueprint's engineering-workflow scope. The predict-then-reveal hard-ordering rule (no interpretive content before the user's prediction lands) is elegant pedagogy with no home in the blueprint.

### Shared subagent template (Reject / already-covered)

Source: `skills/ce-sweep/references/subagent-template.md`. This was queued as a P1 backlog item in the 2026-05-08 analysis ("shared subagent template with persona calibration"); the delta's realization of it is sweep-specific (a media-analyzer template). On inspection its generic core — seed a fresh subagent with a persona, a single scratch-artifact write path, a read-only rule, an untrusted-data rule, and "return only a compact summary plus the artifact path" — is already present in the blueprint's agent-definition conventions (tool-restriction tiers), the review-swarm output-contract (return a path + gist, not inline bulk), and the imported untrusted-data rule. Downgrade from queued-P1 to already-covered.

## Already-covered / not re-adjudicated

- **ce-code-review thematic triage grouping** (the one clearly-dated delta feature, cli-v3.13.0) — grouping review findings by theme. The blueprint's `findings-synthesizer` already clusters and dedupes findings with per-severity gates; at least as sophisticated. Already-covered.
- **Model-tiers degradation rule** — CE dispatches by task shape (extraction/generation/ceiling) never by model name, and degrades to inherit-plus-read-budgets when the platform can't select per-agent models. The blueprint completed effort-tiering across 29 agents in this same platform-sync sweep (U3), defaulting to `model: inherit` with opt-in mapping — the same degradation-aware design. Already-aligned.
- **Correction-cost-gated proactive cross-check offer** — tied to the rejected cross-model panel; not separable.
- The 3 remaining queued P1s from the 2026-05-08 CE v3.7.0 analysis (multi-tier finding classification, conditional persona activation) are baseline-queue items, not delta items, and were not re-adjudicated here except where the delta touched them (shared subagent template, above).

## Operational notes

- **Ground truth is the source, not the changelog.** Because no changelog documents plugin 3.14 to 3.19, any future CE re-analysis must read the skill source directly and must not trust a version label for feature attribution.
- **The one import that matters is blindspot-pass.** It is small, additive, philosophically aligned, and fills a grep-confirmed gap. If Gate 2 approves only one CE pattern, approve that one.
- **Ecosystem table.** CE remains the 17th row; this delta does not add a repo, it re-analyzes an existing one at a new version (v3.7.0 baseline to v3.19.0 pin).
