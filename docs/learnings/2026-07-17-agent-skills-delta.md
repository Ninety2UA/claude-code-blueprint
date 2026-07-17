---
title: "addy-osmani/agent-skills delta (0.6.0 → 0.6.4): skill-eval framework, security hardening, doubt-driven review"
date: 2026-07-17
status: finalized
category: external-imports
baseline: 2026-05-08
analyzed_version: 0.6.4
analyzed_commit: 98967c45a42b88d6b8fb3a88b7ff6273920763d6
applies_when:
  - Reviewing the ecosystem table delta for a previously-analyzed repo
  - Adding or maintaining skills where description collisions could mis-route
  - Sharpening how review subagents are dispatched (anti-confirmation-bias)
  - Extending injection / untrusted-input guidance with an OWASP-LLM lens
tags: [imports, ecosystem, delta, skill-evals, collision-detection, doubt-driven, security, owasp-llm]
---

# addy-osmani/agent-skills delta analysis

**Gate 2 outcome (2026-07-17): approved.** Cross-skill collision detection, the OWASP-LLM lens, and doubt-driven reviewer hygiene were imported and shipped in v3.5.0. This is a delta re-analysis (unit U11) covering only what is new since the 2026-05-08 baseline.

Source: <https://github.com/addyosmani/agent-skills> (MIT, by Addy Osmani). 18th repo in the ecosystem table; previously analyzed 2026-05-08 (see <addy-osmani-agent-skills-imports.md>).

## Version pin and the v1.0.0 discrepancy

- **Real current version: `0.6.4`**, published 2026-07-12, commit `98967c45a42b88d6b8fb3a88b7ff6273920763d6`.
- Full tag list at analysis time: `0.5.0`, `0.6.0`, `0.6.1`, `0.6.2`, `0.6.3`, `0.6.4`. **There is no `1.x` tag and no `v1.0.0`.** The repo has never released a 1.x.
- The 2026-05-08 baseline doc (and MEMORY.md) record the source as **"v1.0.0"** — this matches no git tag and is incorrect. On 2026-05-08 the live version was **`0.6.0`** (released 2026-04-28; `0.6.1` did not ship until 2026-05-23). Treat the prior "v1.0.0" as a recording error; the true baseline is **0.6.0**.
- **Delta analyzed here: `0.6.1` → `0.6.4`** (releases 0.6.1 / 0.6.2 / 0.6.3 / 0.6.4).

## Verdict summary

**Import 3 (1 P1, 2 P2), defer 2, reject 8.** The delta is dominated by app-domain skill content and multi-platform distribution — both out of scope or already-rejected. One genuinely novel, gap-filling idea surfaced (cross-skill description-collision detection), plus two crisp prose patterns. The baseline's structural verdict still holds: their orchestration and multi-agent story remain far weaker than ours, and their new eval Tier 3 is the exact "JSON benchmark + runner scripts = factory tooling" this project rejected on 2026-03-23.

## Verdict table

| Candidate (version) | Verdict | One-line rationale |
|---------------------|---------|--------------------|
| Cross-skill description-collision detection — eval Tier 2 (0.6.4) | **P1 import (idea)** | Novel: catches two skills that mis-route on the same prompt — our single-skill trigger test can't. Import the discipline + a lightweight check, not their Node runner. |
| Anti-confirmation-bias reviewer discipline — doubt-driven-development (0.6.1) | **P2 import (prose)** | "Strip your claim, feed the reviewer only artifact+contract, demand disproof not approval." Sharpens review-swarm dispatch. Dedup-flag: overlaps U10 (CE) / U12 (superpowers). |
| OWASP-LLM Top 10 framing + "system prompt is not a security boundary" — security-and-hardening (0.6.2/0.6.4) | **P2 import (prose)** | Targeted addition to existing untrusted-input rule; do NOT adopt the full app-security skill. |
| Structural skill-linting in CI — eval Tier 1, `validate-skills.js` (0.6.1/0.6.4) | **Defer** | Real gap (nothing enforces our writing-skills template), but overlaps U8's drift gate + CI wiring — reconcile before adopting. |
| Install-script / npm lifecycle-script gate (0.6.4 security pass) | **Defer** | Novel supply-chain guardrail, topical re: npm postinstall worms — but it is prose guidance, not a hook, and our own supply chain is tiny. Bookmark for when scaffold ships JS/npm projects. |
| Behavioral eval runner — eval Tier 3, `run-evals.js --behavioral` (0.6.4) | **Reject** | JSON-schema cases + Node runner + LLM-grader = the factory tooling rejected 2026-03-23. Our subagent-based testing-skills approach is the deliberate choice. |
| Native Codex support (0.6.4) | **Reject** | Explicitly "distribution-focused, not a new prompting pattern." Multi-platform converter already rejected in baseline; we ship a separate codex plugin for a different purpose. |
| Native Antigravity CLI support (0.6.2) | **Reject** | Distribution plumbing for another host. Same rationale as Codex. |
| Full security-and-hardening app skill — STRIDE / OWASP-web / bcrypt / CSP (0.6.2) | **Reject** | Scope creep: we are a meta-framework for AI-assisted dev, not a web-app security guide. Keep only the LLM-lens prose (P2 above). |
| interview-me skill (0.6.1) | **Reject** | Define-phase elicitation; our brainstorming (rigor probes, blindspot pass, premise challenge) is richer. Already-covered, as at baseline. |
| observability-and-instrumentation, `/webperf` + web-performance-auditor, perf/a11y/observability checklists (0.6.2/0.6.3) | **Reject** | App-domain skills and checklists, out of scope for the template. |
| New app-dev skill content — dependency-upgrade, DB schema migration, a11y-first Playwright locators (0.6.4) | **Reject** | Content deepening of app-dev skills we deliberately do not ship. |

## What to import

### P1 — Cross-skill description-collision detection (idea, not their runner)

Their eval framework (`evals/`, 0.6.4) is a three-tier system. Tier 2 is the novel part: a **deterministic, zero-token, CI-gated** check that (a) verifies each skill's positive prompts rank that skill in the top-k, and (b) **flags description collisions between skills** — warn at >=50% description similarity, fail at >=75%. It tracks a "trigger rank-1 rate" as a planned gated CI threshold. Their 0.6.3 release adds a matching authoring-time guardrail that steers new-skill work away from duplicating an existing skill.

**Why this is a real gap.** We already imported single-skill trigger testing on 2026-03-23 (`writing-skills/testing-skills-with-subagents.md`, 20-query positive/negative eval sets). That answers "does MY skill trigger?" — it does **not** answer "do skill A and skill B both claim the same trigger phrases?" With 55 skills and an active import pipeline still adding more, cross-catalog description collision is the exact mis-routing failure mode we care about, and nothing currently catches it.

**What to import — the discipline, not the code.** Consistent with "import ideas not code":

- Add a pre-authoring guardrail to `writing-skills/SKILL.md`: before adding a skill, check its `description:` trigger phrases do not collide with an existing skill; overlapping triggers mean mis-routing.
- Extend `writing-skills/testing-skills-with-subagents.md` from single-skill trigger testing to a cross-skill collision pass over the catalog.
- Optionally add a lightweight deterministic CI check (alongside markdownlint / shellcheck) that computes pairwise `description:` similarity and warns/fails at the >=50% / >=75% thresholds. This is a small deterministic lint, not the full Tier 3 harness.

Do **not** adopt their `evals/cases/<skill>.json` schema or `run-evals.js` runner wholesale.

### P2 — Anti-confirmation-bias reviewer discipline (doubt-driven-development, 0.6.1)

Their `doubt-driven-development` skill codifies in-flight adversarial verification with one genuinely portable rule set. Core loop: CLAIM -> EXTRACT -> DOUBT -> RECONCILE -> STOP. The load-bearing idea, which our review machinery does not state explicitly:

- **Never pass your claim or reasoning to the reviewer — it biases toward agreement.** The reviewer sees only the artifact and its contract.
- **The adversarial prompt must demand "find issues," not "is this good?"** ("A confident answer is not a correct one.")
- Classify findings (contract-misread / actionable / trade-off / noise); stop at trivial-only, 3 cycles, or user override; escalate if 3 cycles leave substantive issues unresolved.

**Why it fits.** Our review-swarm / findings-synthesizer / iterative-refinement are our strongest area, but they are about *how many* reviewers and *how to synthesize* — not about *not leading the witness*. If swarm reviewers currently receive the author's framing or conclusion, adopting "feed only artifact + contract, demand disproof" is a cheap confirmation-bias reduction. Home: review-swarm dispatch prose + `findings-synthesizer` + `iterative-refinement`.

**Dedup flag for Gate 2:** this "adversarial fresh-context reviewer" pattern likely overlaps candidates from U10 (compound-engineering: ce-proof / ce-pov) and U12 (obra/superpowers verification). It may be better-sourced from one of those. Consolidate before importing so we adopt the rule once, in one home.

### P2 — OWASP-LLM Top 10 lens for our injection guidance (security-and-hardening, 0.6.2/0.6.4)

Their `security-and-hardening` skill is mostly app-security (STRIDE, OWASP-web, bcrypt, CSP) — out of scope for us (reject, below). But it carries a sharp LLM-specific section worth a **targeted prose graft** onto our existing untrusted-input rule:

- Map to OWASP Top 10 for LLM Applications (2025): LLM01 prompt injection, LLM05 improper output handling, LLM06 excessive agency, LLM10 unbounded consumption.
- The quotable principle we do not currently state: **"The system prompt is not a security boundary; enforce permissions in code."** Pairs with LLM06 "scope tool permissions, require confirmation for destructive actions" — which our agent tool-restriction tiers already implement, so this names the discipline we already follow.
- "Treat all model output as untrusted input" extends the "error output is untrusted data" rule we imported from this same repo on 2026-05-08 (currently in `systematic-debugging`).

Home: append to the existing untrusted-input rule in `systematic-debugging` (and/or the prompt-guard / read-injection-scanner docs). **Do not create a new security skill** — that is the scope creep we reject below.

## What to defer

- **Structural skill-linting in CI (eval Tier 1 / `validate-skills.js`).** Mechanically enforces frontmatter, naming, and required sections across all skills. Genuine gap — our writing-skills template mandates sections (Common Rationalizations, When NOT to Use) but nothing enforces them. Deferred only because it overlaps **U8 (drift gate + CI wiring)**; reconcile with whatever U8 shipped before adding a second CI validator. If U8 already lints skill structure, this is redundant; if it does not, promote this to a P2.
- **Install-script / npm lifecycle-script gate.** Their 0.6.4 security pass adds "an install-script gate that blocks unreviewed lifecycle scripts before the first install — the exact hole the recent npm postinstall worms used." Innovative and topical, but it is prose/dependency guidance, not a Claude Code hook (the `hooks/` directory is unchanged from baseline), and our own supply chain is a handful of bash/JS hook handlers plus markdown. Bookmark for the day `/project-start` scaffolds JS/npm projects that would benefit from shipping this guardrail downstream.

## What to reject or ignore

- **Behavioral eval Tier 3 (`run-evals.js --behavioral`).** Materializes fixtures, runs the agent with `--permission-mode acceptEdits`, captures the trace, and LLM-grades observable behavior against `evals/cases/<skill>.json` (Anthropic skill-creator schema). This is precisely the "Python/Node scripts, JSON benchmark schemas — factory tooling, not workshop tooling" this project examined and rejected on 2026-03-23 when importing from Anthropic skill-creator. Our subagent-run testing-skills approach is the deliberate, documented choice. Reject and cite the precedent.
- **Native Codex support / native Antigravity CLI support.** Distribution-only (`.codex-plugin/plugin.json` reading `skills/` directly; per-host command mirrors). The baseline already ignored their multi-platform converter; we are a Claude Code plugin, and our separate codex plugin serves a different purpose (Codex-as-a-tool, not the blueprint-as-a-Codex-plugin).
- **Full security-and-hardening app skill.** STRIDE modeling, OWASP-web Top 10, password hashing, security headers, SSRF/upload hardening — valuable for an app, out of scope for a meta-framework. Keep only the LLM-lens prose (P2 above).
- **interview-me (Define-phase elicitation).** Our `brainstorming` + `ideation` + `ce-brainstorm` already cover this more richly (parallel codebase scan, blindspot pass, premise challenge). Already-covered, exactly as the baseline found for their `idea-refine`.
- **observability-and-instrumentation, `/webperf` + web-performance-auditor persona, and the perf / a11y / observability reference checklists.** App-domain skills and checklists. Out of scope; where our users need these, host-native skills already exist outside the blueprint.
- **New app-dev skill content (0.6.4):** dependency-upgrade workflow in code-review-and-quality, DB schema-migration content in deprecation-and-migration, accessibility-first Playwright locators. Content deepening of app-dev skills we deliberately do not ship.
- **Marketplace improvements and the "honest comparison" doc.** Distribution and meta-marketing; nothing to import.

## Overlap flags for Gate 2 (cross-unit dedup)

- **Tier 1 structural skill-linting ↔ U8 (drift gate + CI wiring).** Do not add a second skill validator if U8 covers it.
- **Doubt-driven anti-bias reviewer ↔ U10 (compound-engineering: ce-proof / ce-pov) and U12 (obra/superpowers verification).** Same "adversarial fresh-context reviewer" pattern is likely surfacing from three sources — import the rule once, in one home.

## Trust boundary (how this analysis was conducted)

Read-only inspection of GitHub source and release notes at the pinned tag `0.6.4` (commit `98967c45`). No fetched script or hook was executed; all fetched text was treated as untrusted data. Inspection was read-only; the imports were re-implemented from the described ideas, never copied from source.
