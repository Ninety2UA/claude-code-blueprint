# Project Status

Last updated: 2026-03-09 (v2.2.0)

## Current State of the Code

- **Build:** n/a (template repo, no build step)
- **Tests:** CI should pass (threshold-based counts, 33 > 20)
- **Lint:** shellcheck and markdownlint not re-run this session
- **Last verified:** 2026-03-09 (CI not re-run after v2.2.0)
- **Version:** 2.2.0 (33 skills, 25 agents, 22 commands, 4 hooks)

## In Flight

| Task | Status | Blockers | Notes |
|------|--------|----------|-------|
| (none) | — | — | — |

## Up Next

| Task | Status | Blockers | Notes |
|------|--------|----------|-------|
| (none) | — | — | — |

## What's Done

| Date | Commit | Description |
|------|--------|-------------|
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
| 2026-03-09 | v2.2.0: Add tool restrictions (least privilege), Agent Teams integration, worktree isolation, quality gate hooks | — |
| 2026-03-09 | v2.0.0: Organize agents into swarm/wave/loop teams; add per-project config; add knowledge compounding | — |
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

## Dependencies and External Blockers

- Mermaid CLI (`mmdc` v11.12.0) required for diagram regeneration — installed at `/opt/homebrew/bin/mmdc`
- GitHub CLI (`gh`) required for repo management — authenticated as Ninety2UA
