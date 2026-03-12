# Project Status

Last updated: 2026-03-12

## Current State of the Code

- **Build:** n/a (template repo, no build step)
- **Tests:** CI passing (4/4 jobs green — install ubuntu, install macos, shellcheck, markdownlint)
- **Lint:** markdownlint clean, shellcheck clean
- **Last verified:** 2026-03-12 (CI run after commit `0808b6f`)
- **Version:** 2.3.0 (34 skills, 26 agents, 24 commands, 5 hooks)

## In Flight

| Task | Status | Blockers | Notes |
|------|--------|----------|-------|
| (none) | — | — | — |

## Up Next

| Task | Status | Blockers | Notes |
|------|--------|----------|-------|
| (no immediate work) | — | — | v2.3.0 is fully documented and CI is green |

## What's Done

| Date | Commit | Description |
|------|--------|-------------|
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
| 2026-03-11 | Dual-loop context management: external bash loop (`ship.sh`) for context exhaustion, Stop hook (`ship-loop.sh`) for premature exit, `--external` flag to avoid conflict | — |
| 2026-03-11 | v2.3.0: `/ship` as autonomous pipeline name, team-lead as dedicated agent (not skill), `--no-review` composability pattern, 3 iteration layers (task/quality/session), plan-checker verify loop before execution | — |
| 2026-03-09 | v2.2.0: Add tool restrictions (least privilege), Agent Teams integration, worktree isolation, quality gate hooks | — |
| 2026-03-09 | v2.0.0: Organize agents into swarm/wave/loop teams; add per-project config; add knowledge compounding | — |
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
