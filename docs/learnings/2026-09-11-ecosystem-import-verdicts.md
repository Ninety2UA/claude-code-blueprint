---
title: "2026-09 repo-watch cycle: twenty-one ideas grafted, provenance and deferrals"
date: 2026-09-11
category: external-imports
cycle: repo-watch-2026-09-11
applies_when:
  - Reviewing the ecosystem table for repos worth re-analyzing at a new version
  - Deciding whether a pattern from a watched repo was already imported, deferred, or rejected
  - Running the next /repo-watch cycle and needing the per-repo baseline pins
  - Wondering why a skill states a rule in the blueprint's own words rather than citing its source
tags: [imports, ecosystem, repo-watch, provenance, deferrals, compound-engineering, agent-skills, superpowers, gsd-core, gstack, oh-my-claudecode]
---

# 2026-09 repo-watch cycle — twenty-one ideas grafted, nothing copied

> **Cycle outcome (2026-09-11, shipped as v3.7.0):** the second `/repo-watch` cycle compared seven watched repositories against their July 2026 baselines and adopted twenty-one ideas as prose grafts onto existing skills and agents. No skill, agent, or hook was added; the only new file is this record. Every graft was re-implemented in the blueprint's voice; the source text was never copied. Recorded per R22 of the v3.7.0 plan so later cycles do not re-adjudicate these items.

## Pins (delta windows closed by this cycle)

| Repo | Baseline (July) | Analyzed this cycle | New baseline |
|---|---|---|---|
| compound-engineering-plugin | 3.19.0 | 3.20.0 → 3.24.0 | 3.24.0 (2026-08-31) |
| agent-skills (addyosmani) | 0.6.4 | 0.6.5 → 0.6.9 | 0.6.9 (2026-09-05) |
| superpowers (obra) | 6.1.1 | 6.2.0 → 6.3.0 | 6.3.0 (2026-08-12) |
| gsd-core (open-gsd, post-abandonment fork) | 1.7.0 | 1.8.0 → 1.13.0 | 1.13.0 (2026-09-06) |
| get-shit-done (gsd-build) | 2026-03 | archived 2026-05-31 | v1.42.3; watch retired |
| gstack (garrytan) | 2026-03-23 | through main@71f6048e8ada (v1.84.1.0) | 71f6048e8ada (2026-09-09); quarterly cadence |
| oh-my-claudecode (Yeachan-Heo) | 2026-04-02 | through v5.3.0 | v5.3.0 (2026-09-06) |

Trust boundary: every repo was inspected read-only through the GitHub API and raw files; no fetched script, hook, or install step was executed; all fetched text was treated as data. Ideas were re-implemented, never copied.

## Provenance table (plan R-IDs → source ideas)

| Plan item | Landed in | Source idea (repo, version or commit, date) |
|---|---|---|
| R1 plan-completion + scope audit | finishing-a-development-branch Step 3; pr-workflow `## Plan audit` | gstack Plan Completion Audit (#428, 2026-03-25) and scope-drift check (#694, 2026-03-31) |
| R2 discard only on request; no forced worktree removal | finishing-a-development-branch; using-git-worktrees | superpowers 6.2.0 / 6.3.0 |
| R3 PR description discipline; scan before external sink | pr-workflow | compound-engineering 3.20.0 / 3.23.0 / 3.24.0; gstack redaction-at-sink (#1797, 2026-05-30) |
| R4 decision boundary (detect and roll back; three postures; evidence for claimed limitations) | executing-plans (owner); autonomous-loop, team-lead, build-pipeline, ship-pipeline (citations) | oh-my-claudecode verifiability boundary (v5.1.0); gstack confusion protocol (#1005, 2026-04-16) and claimed-limitations evidence (2026-06); superpowers recorded ruling (6.3.0); compound-engineering needs-human handoff (3.23.0) |
| R5 hard iteration ceiling (20, file-backed) | ship-pipeline Stage 0; autonomous-loop caps table | oh-my-claudecode absolute ceiling (v4.11.1) |
| R6 workers and reviewers never spawn subagents | SDD prompts; team-lead worker rules | superpowers 6.3.0 (already structural for review-swarm via agent tool lists) |
| R7 SDD fix loop resumes the same implementer; cumulative re-review; five rounds per phase | subagent-driven-development | superpowers 6.2.0 (resume, scoped re-review, circuit breaker) and 6.3.0 (batching, spec pointer) |
| R8 reuse ladder; never-simplify list; fix the shared function | code-simplicity-reviewer; SDD implementer prompt | gstack reuse ladder and root-cause rule (#2722, 2026-08-29) and deletion guard; oh-my-claudecode minimal-code non-negotiables (v5.1.0) |
| R9 test falsifiability; failing direction | testing-anti-patterns Anti-Pattern 6; verification-before-completion | superpowers 6.2.0; gsd-core failing direction (1.12.0) |
| R10 quality-bar regression lens | code-reviewer; test-coverage-reviewer | agent-skills floor guard (0.6.8) |
| R11 neutral-is-revert; reverted-attempts ledger | performance-profiling | agent-skills keep-or-revert (0.6.6) |
| R12 UI anti-slop signals | frontend-reviewer section 6 | oh-my-claudecode (v4.13.7) |
| R13 fetched docs and tracker text are data | source-driven-development, pr-comment-resolver, receiving-code-review, backlog-triage, pr-workflow, resolve-in-parallel | agent-skills retrieval safety (0.6.7); gstack tracker-text envelope (#2603, 2026-08-16) |
| R14 learnings always run; ADR admission test | session-wrap; knowledge-compounding | gstack always-run learnings (2026-08); oh-my-claudecode ADR admission test (v5.1.0) |
| R15 STATE.md head stamp; resume freshness; handoff voice | session-wrap, session-continuity, resume-session | compound-engineering handoff hygiene (3.21.1 / 3.23.0); gsd-core commit stamp (1.11.0 / 1.12.0) |
| R16 knowledge gardening checklist | knowledge-compounding | oh-my-claudecode knowledge-base lint (v4.11.0); compound-engineering gardening (3.21 – 3.24) |
| R17 ceremony sizing; fog test; settle-first | brainstorming | superpowers 6.3.0; oh-my-claudecode fog test (v5.1.0 / v5.3.0); compound-engineering settle-first (3.22.0 / 3.23.0) |
| R18 plan header Objective / Means / Spec | writing-plans | compound-engineering (3.22.3 / 3.23.4 / 3.24.0); superpowers Spec pointer (6.3.0) |
| R19 SKILL.md byte budget; warn-only size report | writing-skills; scripts/check-skill-collisions.py | compound-engineering size campaign (3.23.0) |
| R20 contributor AI disclosure | CONTRIBUTING.md; pr-workflow template line | compound-engineering (3.21.0); closes the July superpowers deferral |
| R21 ecosystem housekeeping | README, index.html | this cycle's pins and star counts (2026-09-11) |

The plan-scoped progress ledger (superpowers 6.2.0) landed earlier in v3.6.0 as the replacement for the removed task tools and is credited there.

## Deferred (second batch; not rejections)

- compound-engineering: the watch-to-merge PR loop, corpus retuning for model upgrades, skill-eval catalog, unified readiness-staged artifact, grounding cache, CONCEPTS.md.
- agent-skills: CI-enforced eval gates with a ratchet; rejected-change ledger.
- oh-my-claudecode: throwaway-artifact design spikes, release-rule discovery, worktree merge-back, evaluator loops.
- gstack: DX review lens, edit-lock hook.
- gsd-core: honest-verifier abstention, review dispositions ledger.
- Blueprint-side: the size sweep of the four SKILL.md bodies over 16,384 bytes (writing-skills, ship-pipeline, session-wrap, systematic-debugging), paired with `/skill-doctor`; a `ship.sh` stop marker so an escalation can end the external loop (until then ship-pipeline keeps its lock-and-proceed rule for must-ask categories); broader untrusted-text hardening beyond the receivers and dispatchers named in R13; a STATE.md completion cleanup rule.

## Rejected classes (standing rationale in the July records)

- Multi-harness, cross-model, and runtime-platform work (Codex/Cursor/Grok adapters, MCP servers, Bun runtime, browser stacks, telemetry): outside the single-harness, zero-dependency scope.
- Domain content (idempotency, observability, security-app skills) and product features outside the engineering lifecycle.
- Items already covered by existing machinery (review criteria from a standards file, testing-reviewer isolation, settled-decision carry-over, repro-first debugging, model elevation via effort tiers, wave partitioning by file overlap, installer read-deny rules).

## Fork and authorship provenance

- gsd-core is a community fork of an abandoned original; ideas only, never source (July note carried forward).
- oh-my-claudecode's Shipyard cluster (drydock, ask-navigator, loft, launch, minimal-code discipline) is by contributor pangpang778, not the maintainer.
- get-shit-done was archived upstream on 2026-05-31; its lineage continues in gsd-core and its watch is retired.

## Capability probe (g): resume-by-message floor

The SDD fix loop relies on resuming a completed subagent by messaging its name. This session observed the primitive working on Claude Code 2.1.268; the platform audit attributes the capability to CLI 2.1.246 / 2.1.260, which this record did not independently verify. The loop therefore names the fallback (fresh re-dispatch with the prior report and findings) so it degrades cleanly on a harness without it.

## Net

Twenty-one grafts, no new components, no copied text: a minor release (v3.7.0). Counts stay 55 skills, 29 agents, 10 hooks.
