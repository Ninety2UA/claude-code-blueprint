# Project Instructions

## Philosophy

**Each unit of engineering work should make subsequent units easier — not harder.**

Quality over speed. Small steps compound. The patterns you establish will be copied. The corners you cut will be cut again.

## Session Continuity

<!-- Updated by /wrap. Full history: git log + docs/learnings/ -->

**Last session:** 2026-07-19

**What was done:** Platform-sync cycle shipped and closed out — v3.4.0 + v3.5.0 merged to `main` (PR #3), followed by release housekeeping and verification passes:
- Git tags + GitHub Releases backfilled; chain complete v3.2.1 → v3.5.0 (Latest), notes sourced from README What's New.
- Docs/visual pass: 5 new premium diagrams, all 17 re-rendered at 2× (`docs/images/render-diagrams.js`), new "Platform Currency" homepage section.
- Promo pipeline repaired (PR #4): `record-promo.js` root path fixed, system-Chrome fallback, mp4→GIF conversion added; stray `icon.png` removed.
- Watcher rename reflected publicly (PR #5): the workspace `/platform-sync` radar is now `/cli-watch` + `/repo-watch` (workspace-level, not in the plugin). "Platform-sync cycle" is kept where it names the historical cycle.
- Post-merge verification loop: live site inspected at desktop + mobile (chrome-devtools CLI), console clean, CI green, Pages current. Caught stale promo scenes the GIF regeneration had preserved (old 35/26/27/6 stat cards incl. a defunct Commands category, legacy `/planning` `/build` `/review` `/ship` names, v2.x install command) — fixed the source, re-rendered `overview.gif`/`.mp4`, and extended the drift gate to cover `promo-video.html`.

**What's remaining:**
- `bug-reproduction-validator` agent is unreferenced by any skill — consider integrating into systematic-debugging.

**Start here:** `main` is current and fully released (v3.5.0 tagged, Pages live). Monthly watchers `/cli-watch` + `/repo-watch` are ready to run on schedule.

**Current state of the code:**
- Build: n/a (template repo, no build step)
- Gates: drift gate (now also gating `promo-video.html`) + skill-collision gate green; markdownlint + shellcheck clean locally
- Website: live at <https://ninety2ua.github.io/claude-code-blueprint/>
- Uncommitted changes: none

## Skills

No build step (template repo). Key skills for installed projects:

| Skill | Purpose |
|-------|---------|
| `/build-pipeline` | Supervised pipeline — checkpoints between every stage |
| `/ship-pipeline` | Autonomous pipeline — zero checkpoints, fire-and-forget |
| `/quick-fix` | Fast-track small changes (< 3 files) with TDD |
| `/ideation` | Generate and rank improvement ideas |
| `/brainstorming` | Brainstorm before building |
| `/review-swarm` | Multi-agent parallel code review |
| `/deep-research` | Multi-agent parallel research |
| `/orchestrate` | Wave-based parallel execution (dependency-ordered) |
| `/team-execution` | Collaborative agent team (shared task list + messaging) |
| `./scripts/ship.sh "feature"` | External loop — fresh context per iteration |
| `/plugin-update` | Update plugin to latest version from GitHub |

Run `/project-start` after install to configure `docs/context/CONVENTIONS.md` with actual lint/test/dev commands.

## Architecture

```
.claude-plugin/                          # Marketplace manifest (marketplace.json)
plugins/claude-code-blueprint/           # Plugin root
  skills/                                # 55 skills (slash commands + workflows)
  agents/                                # 29 specialized subagents
  hooks/hooks.json                       # Hook definitions (${CLAUDE_PLUGIN_ROOT})
  hooks/handlers/                        # Hook scripts (session-start, context-monitor, etc.)
  templates/                             # Project scaffolding source (copied by /start)
    CLAUDE.md, BACKLOG.md, docs/...      # Template files for new projects
  scripts/ship.sh                        # Ralph-style external loop for /ship
  .claude-plugin/plugin.json             # Plugin manifest
docs/images/                             # README images (repo-only)
install.sh                               # Plugin installer + legacy mode
```

Skills and agents are self-describing via frontmatter — read their files for when/how to use them.

Each agent carries an `effort:` tier (`low`/`medium`/`high`) in frontmatter, set by reasoning depth (mechanical validators → `low`; workers/researchers → `medium`; reviewers/synthesizers/oracles/orchestrator → `high`). Default stays `model: inherit` so agents ride the session model; an opt-in per-agent model mapping (`low`→Haiku 4.5, `medium`→Sonnet 5, `high`→Opus 4.8 / Fable 5) is documented in README under "Effort tiers & opt-in model mapping" — apply only if your plan tier supports it.

## Behavioral Rules

- Do what has been asked; nothing more, nothing less
- ALWAYS read a file before editing it
- NEVER create files unless absolutely necessary for the goal
- Prefer editing existing files to creating new ones
- NEVER proactively create documentation unless explicitly requested
- NEVER commit secrets, credentials, or .env files
- Evidence before claims — run verification before asserting completion
- When in doubt, ask — don't assume intent or make silent decisions
- If you break something while fixing something else, stop and fix the regression first
- Commit working code frequently — don't accumulate large uncommitted changesets

## Deviation Rules

When executing a plan or working autonomously:

**Auto-fix (no permission needed):** logic errors, type errors, missing imports, broken paths, missing error handling, lint issues, typos

**Must ask the user FIRST:** new database tables/migrations, switching frameworks, changing public API contracts, modifying auth logic, adding env vars or external service dependencies, architectural decisions not in ADRs

**Scope boundary:** Only fix issues caused by the current task. Pre-existing issues go in BACKLOG.md.

## Error Handling

- Fail loudly at system boundaries; recover gracefully inside
- Log context needed to reproduce, not just the error message
- Never swallow errors silently
- Validate inputs at the edges; trust data already inside the system

## Error Recovery

- **Failed test:** Use systematic-debugging skill — gather evidence, form hypothesis, test it
- **Merge conflict:** Read both sides, understand intent before resolving
- **Broken build after dep update:** Pin previous version, add BACKLOG item
- **Corrupted worktree:** Fresh worktree from main, cherry-pick completed commits
- **Agent unexpected results:** Verify findings manually before acting
- **Lost work:** Check `git stash list`, `git reflog`, `git fsck --lost-found`

## Analysis Paralysis Guard

5+ consecutive read-only operations without writing code → STOP. Either write code, report a blocker, or ask for help.

## Lightweight Workflow

For small, well-understood changes (< 3 files, obvious root cause):
1. Write failing test → 2. Fix → 3. Verify → 4. Commit

If touching 4+ files, adding new API, or changing data models → use full workflow (`/brainstorming` → `/build-pipeline`).

## Code Quality

- Files under 500 lines — split if longer
- Typed interfaces for public APIs
- Write tests FIRST (red-green-refactor)
- DRY, YAGNI — no dead code, no features beyond what's asked
- Run linter and tests before every commit
- One logical change per commit
- No TODO comments without BACKLOG.md entry
- No commented-out code — git remembers

## Commit Conventions

Format: `type(scope): brief description`

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`

## Pipelines

| Pipeline | Checkpoints | Review | Best For |
|----------|-------------|--------|----------|
| `/build-pipeline` | Between every stage | Single pass (or `--iterate N`) | Features needing human guidance |
| `/ship-pipeline` | None (fully autonomous) | Iterative (default 3 cycles) | Well-defined features, fire-and-forget |
| `/quick-fix` | None | None | Trivial changes (< 3 files) |

## Context Loading Order

1. **SessionStart hook** — auto-bootstraps project state
2. **CLAUDE.md** (this file)
3. **docs/context/STATUS.md** — current state, commit history, known issues
4. **docs/context/CONVENTIONS.md** — tech stack, naming, patterns (read before writing code)
5. **docs/context/DECISIONS.md** — locked decisions that MUST be honored
6. **docs/context/GOALS.md** — when prioritizing work
7. **BACKLOG.md** — when looking for what to work on next
8. **blueprint.local.md** — which agents are active for this project's stack

## Gotchas

- Plugin hook scripts live at `hooks/handlers/` (referenced via `${CLAUDE_PLUGIN_ROOT}` in hooks.json)
- Hook definitions use nested format: `"hooks": [{"hooks": [...]}]` — missing the inner array silently fails
- The Read tool cannot access plugin files (sandbox restriction) — skills must be invoked by name, not file path
- Stop hook `"decision": "block"` does NOT reset context — use `scripts/ship.sh` for true context refresh between iterations
- Each Agent Teams teammate MUST own specific files — concurrent modification causes conflicts
- Use `execFileSync` not `execSync` in hook scripts to prevent shell injection
- `docs/images/*` excluded from install — only for template's GitHub README display

## Key Learnings

See `docs/learnings/` for project-specific patterns, gotchas, and insights — one doc per import/analysis cycle (e.g. `pipeline-discipline.md`, `addy-osmani-agent-skills-imports.md`). Updated by `/session-wrap`.
