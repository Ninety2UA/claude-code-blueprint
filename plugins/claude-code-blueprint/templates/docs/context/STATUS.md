# Project Status

Last updated: 2026-03-26

## Current State of the Code

- **Build:** n/a (template repo, no build step)
- **Tests:** CI pending on `5a0c352` — last full green on `c5b512e`
- **Lint:** markdownlint clean, shellcheck clean
- **Last verified:** 2026-03-26
- **Version:** 2.3.0 (34 skills, 26 agents, 24 commands, 6 hooks)

## In Flight

| Task | Status | Blockers | Notes |
|------|--------|----------|-------|
| (none) | — | — | — |

## Up Next

| Task | Status | Blockers | Notes |
|------|--------|----------|-------|
| (no feature work) | — | — | v2.3.0 in maintenance mode, all commits pushed |

## What's Done

| Date | Commit | Description |
|------|--------|-------------|
| 2026-03-26 | `5a0c352` | Fix: system audit findings — version bump 2.2.0→2.3.0, plugin.json counts, CLAUDE.md architecture accuracy. |
| 2026-03-26 | `b147f0c` | Refactor: move Key Learnings from CLAUDE.md to `docs/learnings/LEARNINGS.md`, update `/wrap` skill. |
| 2026-03-26 | `1f15426` | Refactor: optimize CLAUDE.md from 527→149 lines (72% reduction) — remove redundant tables, historical learnings. |
| 2026-03-26 | `be48616` | Feat: add `--update` flag to install.sh — refresh template without losing customizations. |
| 2026-03-26 | `43f9145` | Feat: Ralphy-style UI for `scripts/ship.sh` — braille spinner, stage detection, tput colors, iteration logs. |
| 2026-03-25 | `e3711f5` | Fix: migrate hooks to `hooks/hooks.json` with `${CLAUDE_PLUGIN_ROOT}` — fixes PostToolUse errors on plugin auto-discovery. |
| 2026-03-25 | `f492b74` | Fix: include `scripts/ship.sh` in installer + `/dev/tty` stdin pipe fix for overwrite prompt. |
| 2026-03-24 | `c6a1cb4` | Feat: absorb 3 patterns from multi-agent framework analysis — worker failure protocol (team-lead), contradiction resolution (findings-synthesizer), structured escalation (iterative-refinement). README updated with 15th repo entry. 5 files, +66/-10. |
| 2026-03-23 | `0a7a0c4` | Feat: GSD imports — interface context extraction (writing-plans), deviation scope boundary + stub tracking (executing-plans), prompt injection guard hook (new), verification command guideline (writing-plans). 4 modified, 1 new file, +114 lines. |
| 2026-03-23 | `2526608` | Docs: session wrap-up — claude-squad and claude-mem compatibility analyses (verdict: import nothing from either) |
| 2026-03-23 | `4584357` | Docs: session wrap-up — Anthropic skill-creator insights integration |
| 2026-03-18 | `b28a03f` | Docs: update README (gstack integration section), ebook PDF (9 tools), ebook HTML source, session continuity and key learnings. |
| 2026-03-18 | `1d1ed2e` | Feat: incorporate 15 gstack patterns — suppressions lists for 5 reviewer agents, AI Slop detection, confidence tiering, WTF-likelihood risk scoring, premise challenge + scope modes, shadow path tracing, error/rescue maps, completeness principle, AskUserQuestion format. 10 files, +233. |
| 2026-03-16 | `da101c2` | Docs: update README and ebook PDF with GSD-2 integration |
| 2026-03-16 | `d3b8346` | Feat: incorporate GSD-2 mechanisms — error taxonomy, degradation detection, structured escalation, assumption tracking, contradiction detection, summary reconciliation. 6 files, +97/-10. |
| 2026-03-12 | `c5b512e` | Fix: install script image exclusion — use directory wildcard instead of extension denylist (`.mp4`/`.gif` leaked) |
| 2026-03-12 | `0808b6f` | Fix: use animated GIF for README video — GitHub strips `<video>` tags |
| 2026-03-12 | `7e07266` | Feat: add 7-scene animated promo video (HTML/CSS + Playwright screenshots + ffmpeg) |
| 2026-03-12 | `9063694` | Docs: hyperlink all 34 skill names and 26 agent names in README reference tables |
| 2026-03-11 | `28af7a2` | Docs: add dispatch pattern diagrams (swarm, wave, agent team) — replace ASCII art in "How agents work" section |
| 2026-03-11 | `be9aa01` | Docs: add dev-loop and lightweight-workflow diagrams — replace ASCII art in workflow section |
| 2026-03-11 | `eba4393` | Docs: add 5 standalone diagrams (review-swarm, research-swarm, wave-orchestration, agent-teams, knowledge-loop) — replace ASCII art in "Agent Teams & Swarms" section |
| 2026-03-11 | `4dc5408` | Fix: markdownlint MD049 — asterisk emphasis → underscore in CLAUDE.md |
| 2026-03-11 | `26bd912` | Feat: add `/ship` pipeline, `scripts/ship.sh` external loop, dual-loop context management, pipeline diagram, README update with `/ship` section + context management docs. 17 files, +1477/-100. |
| 2026-03-11 | `866abca` | Docs: session wrap-up for v2.3.0 autonomous pipeline and iteration loops |
| 2026-03-11 | (prior session) | Feat: v2.3.0 — autonomous pipeline (`/ship`), iterative refinement skill, team-lead agent, `/deepen` command, Stop hook, circuit breaker, `--no-review` composability. |
| 2026-03-09 | `4605205` | Feat: v2.2.0 — add tool restrictions to all 25 agents, Agent Teams integration (`/team` command, agent-teams skill, quality gate hooks), worktree isolation, README update. 38 files, +616/-46. |
| 2026-03-09 | `611902d` | Feat: v2.1.0 — add 3 skills (dependency-management, spike-exploration, scope-cutting), add `--version` flag to install.sh, update all counts (29 → 32 skills). |
| 2026-03-09 | `aece6df` | Chore: add GitHub Actions CI — lint markdown, shellcheck, install tests on ubuntu+macos. All 4 jobs passing. |
| 2026-03-09 | `06c261d` | Docs: update all diagrams for v2.0.0 — team-based agents-ecosystem, 4 new skills in skills-map, updated counts in hero-banner and project-structure. Re-rendered 6 PNGs. install.sh bumped to v2.0.0. |
| 2026-03-09 | `780a037` | Feat: v2.0.0 — add agent swarms (review/research), wave orchestration, knowledge compounding. +6 agents, +4 commands, +4 skills, blueprint.local.md, docs/solutions/ |
| 2026-03-09 | `98a9fa0` | Docs: redesign all 5 diagrams with HTML/CSS rendering, update hero banner counts, fix ASCII art |
| 2026-03-09 | `7a242a5` | Docs: add Claude Code plugin ecosystem ebook (PDF) and README section |
| 2026-03-05 | `b399f7f` | Feat: add 11 skills, 8 agents, 8 commands — expand blueprint coverage from gap analysis of 5 repos |
| 2026-03-04 | `884d342` | Fix: redesign project-structure diagram — remove arrows, add dark section headers |
| 2026-03-04 | `be83171` | Fix: hero banner title clipping — reduce font, shift terminal right |
| 2026-03-04 | `642f64e` | Templatize CLAUDE.md — replace project-specific content with clean placeholders |
| 2026-03-04 | `0c6c961` | Fix: redesign all 5 README diagrams for GitHub readability — switched from flowchart to block-beta grid layout, SVG to PNG |
| 2026-03-04 | `419bfcf` | Apply review findings: example docs, lightweight workflow, error recovery, brainstorming escape hatch |
| 2026-03-04 | `7531075` | Initial release: full template with 14 skills, 7 agents, 7 commands, install script, README |

## Decisions Made

| Date | Decision | ADR |
|------|----------|-----|
| 2026-03-25 | Hooks belong in `hooks/hooks.json` (plugin mechanism with `${CLAUDE_PLUGIN_ROOT}`), not `settings.json` (project mechanism with relative paths). Fixes auto-discovery path resolution. | — |
| 2026-03-24 | Import 3 patterns from multi-agent coordination framework (worker failure protocol, contradiction resolution, structured escalation). Reject 7: multi-model delegation, file-based coordination, assignment matrix, Phase 0 analysis, CONTRACTS.md, attribution changelog, skip conditions. | — |
| 2026-03-23 | Import 4 GSD patterns (interface context, deviation scope boundary, prompt guard hook, stub tracking). Reject: multi-runtime, CLI layer, milestone lifecycle, model profiles, file locking, workflow guard. Principle: import the judgment, not the machinery. | — |
| 2026-03-23 | Don't import patterns from claude-squad (external process manager) or claude-mem (exhaustive memory capture) — blueprint's internal approach and selective curation are superior for our use case | — |
| 2026-03-23 | Cherry-pick Anthropic skill-creator concepts (description testing, structured assertions, iteration-by-type) into existing writing-skills docs. Reject blind comparison agents, Python scripts, JSON schemas as factory-scale tooling. | — |
| 2026-03-11 | Dual-loop context management: external bash loop (`ship.sh`) for context exhaustion, Stop hook (`ship-loop.sh`) for premature exit, `--external` flag to avoid conflict | — |
| 2026-03-11 | v2.3.0: `/ship` as autonomous pipeline name, team-lead as dedicated agent (not skill), `--no-review` composability pattern, 3 iteration layers (task/quality/session), plan-checker verify loop before execution | — |
| 2026-03-09 | v2.2.0: Add tool restrictions (least privilege), Agent Teams integration, worktree isolation, quality gate hooks | — |
| 2026-03-09 | v2.0.0: Organize agents into swarm/wave/loop teams; add per-project config; add knowledge compounding | — |
| 2026-03-18 | Incorporate gstack patterns: suppressions lists, AI Slop detection, confidence tiering, WTF-likelihood risk scoring, premise challenge + scope modes, shadow path tracing, error/rescue maps, completeness principle. Fix-First excluded — our orchestration handles it differently. | — |
| 2026-03-16 | Incorporate GSD-2 error taxonomy (classify before debugging), flaky test quarantine, degradation signals, assumption ledger, contradiction detection, "never summarize summaries" | — |
| 2026-03-12 | Animated GIF over `<video>` tag for GitHub README — GitHub sanitizer strips `<video>` elements | — |
| 2026-03-12 | Screenshot-based recording (PNG + ffmpeg) over Playwright recordVideo — recordVideo misses DOM mutations in headless mode | — |
| 2026-03-11 | All README ASCII art replaced with rendered PNG diagrams — 10 new sections in render-diagrams.html, zero ASCII remaining | — |
| 2026-03-09 | Switch diagram rendering from Mermaid to HTML/CSS + Playwright screenshots for better quality | — |
| 2026-03-05 | Adopt ralphy autonomous retry loop pattern as autonomous-loop skill | — |
| 2026-03-05 | Expand template based on gap analysis of 5 leading Claude Code repos — 27 new files | — |
| 2026-03-04 | Remove arrows from block-beta diagrams, use dark/light color contrast for hierarchy instead | — |
| 2026-03-04 | Use block-beta grid layout for Mermaid diagrams instead of flowchart LR — better aspect ratios for GitHub | — |
| 2026-03-04 | Switch README images from SVG to PNG — more predictable rendering on GitHub | — |
| 2026-03-04 | Template uses MIT license, public repo, one-line curl installer | — |

## Known Issues

| Issue | Severity | Workaround | Discovered |
|-------|----------|------------|------------|
| docs/context/ files still have placeholder templates | P3 | Filled in by `/init` when user installs | 2026-03-04 |
| README.md doesn't document v2.3.0 components | ~~P2~~ RESOLVED | Fixed in `26bd912` | 2026-03-11 |

## Dependencies and External Blockers

- Mermaid CLI (`mmdc` v11.12.0) required for diagram regeneration — installed at `/opt/homebrew/bin/mmdc`
- GitHub CLI (`gh`) required for repo management — authenticated as Ninety2UA
