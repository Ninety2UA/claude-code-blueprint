# Project Status

Last updated: 2026-03-09

## Current State of the Code

- **Build:** n/a (template repo, no build step)
- **Tests:** CI passing (4/4 jobs — lint-markdown, shellcheck, install ubuntu, install macos)
- **Lint:** markdownlint clean, shellcheck clean
- **Last verified:** 2026-03-09
- **Version:** 2.1.0 (32 skills, 25 agents, 21 commands, 2 hooks)

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
