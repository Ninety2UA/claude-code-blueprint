# Project Status

Last updated: 2026-03-04

## Current State of the Code

- **Build:** n/a (template repo, no build step)
- **Tests:** n/a (install.sh tested manually via dry-run)
- **Lint:** not yet configured
- **Last verified:** 2026-03-04

## In Flight

<!-- Nothing actively in flight — template is deployed and stable. -->

| Task | Status | Blockers | Notes |
|------|--------|----------|-------|
| — | — | — | No active work items |

## Up Next

1. Add GitHub Actions CI — lint markdown, test install script on ubuntu/macos
2. Add more skills — dependency management, spike/exploration, scope cutting
3. Add `--version` flag or release tagging strategy to install.sh
4. Expand example docs with more variety

## What's Done

| Date | Commit | Description |
|------|--------|-------------|
| 2026-03-04 | `884d342` | Fix: redesign project-structure diagram — remove arrows, add dark section headers |
| 2026-03-04 | `be83171` | Fix: hero banner title clipping — reduce font, shift terminal right |
| 2026-03-04 | `642f64e` | Templatize CLAUDE.md — replace project-specific content with clean placeholders |
| 2026-03-04 | `0c6c961` | Fix: redesign all 5 README diagrams for GitHub readability — switched from flowchart to block-beta grid layout, SVG to PNG |
| 2026-03-04 | `419bfcf` | Apply review findings: example docs, lightweight workflow, error recovery, brainstorming escape hatch |
| 2026-03-04 | `7531075` | Initial release: full template with 14 skills, 7 agents, 7 commands, install script, README |

## Decisions Made

| Date | Decision | ADR |
|------|----------|-----|
| 2026-03-04 | Remove arrows from block-beta diagrams, use dark/light color contrast for hierarchy instead | — |
| 2026-03-04 | Use block-beta grid layout for Mermaid diagrams instead of flowchart LR — better aspect ratios for GitHub | — |
| 2026-03-04 | Switch README images from SVG to PNG — more predictable rendering on GitHub | — |
| 2026-03-04 | Template uses MIT license, public repo, one-line curl installer | — |

## Known Issues

| Issue | Severity | Workaround | Discovered |
|-------|----------|------------|------------|
| No CI — install script not automatically tested | P2 | Manual dry-run testing | 2026-03-04 |
| docs/context/ files still have placeholder templates | P3 | Filled in by `/init` when user installs | 2026-03-04 |

## Dependencies and External Blockers

- Mermaid CLI (`mmdc` v11.12.0) required for diagram regeneration — installed at `/opt/homebrew/bin/mmdc`
- GitHub CLI (`gh`) required for repo management — authenticated as Ninety2UA
