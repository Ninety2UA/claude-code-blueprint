# Project Instructions

## Philosophy

**Each unit of engineering work should make subsequent units easier — not harder.**

Quality over speed. Small steps compound. The patterns you establish will be copied. The corners you cut will be cut again.

## Session Continuity

<!-- Updated by /wrap. For full state: read docs/context/STATUS.md -->

**Last session:** 2026-04-02

**What was done:**
- Built GitHub Pages marketing website (`index.html`, 2682 lines) with 13 sections, deployed at https://ninety2ua.github.io/claude-code-blueprint/ (`9a151f0`)
- Fixed hook errors: `context-monitor.js` double processState() race, `ship-loop.sh` set -e + stderr leaks, `prompt-guard.js` timeout race (`9a151f0`)
- Iterated color palette through 5 variants, settled on peach-amber `#f0a875` (`26fb3be`)
- Redesigned workflow section into 5 horizontal cards with colored top accents (`01d7d45`)
- Fixed orchestration card images with `aspect-ratio: 16/10` containers for uniform sizing
- Restructured install section from 2+1 layout to 3-column equal grid with numbered steps
- Added staggered scroll-reveal animations, enhanced hover effects across all card types

**What's remaining:**
- Untracked `docs/images/icon.png` — decide whether to commit or remove
- Add OG image (`og-image.png`) for social preview cards when URL is shared
- `render-graphs.js` uses `execSync` instead of `execFileSync` — cosmetic, low risk

**Start here:** Website is live. No in-flight work. Consider adding OG image for social sharing or further design refinements.

**Current state of the code:**
- Build: n/a (template repo, no build step)
- Tests: CI not run on latest commits
- Website: live at https://ninety2ua.github.io/claude-code-blueprint/
- Uncommitted changes: 1 untracked file (`docs/images/icon.png`)

## Commands

No build step (template repo). Key commands for installed projects:

| Command | Purpose |
|---------|---------|
| `/build` | Supervised pipeline — checkpoints between every stage |
| `/ship` | Autonomous pipeline — zero checkpoints, fire-and-forget |
| `/quick` | Fast-track small changes (< 3 files) with TDD |
| `/plan` | Brainstorm before building |
| `/review-swarm` | Multi-agent parallel code review |
| `/deep-research` | Multi-agent parallel research |
| `/orchestrate` | Wave-based parallel execution (dependency-ordered) |
| `/team` | Collaborative agent team (shared task list + messaging) |
| `./scripts/ship.sh "feature"` | External loop — fresh context per iteration |

Run `/init` after install to configure `docs/context/CONVENTIONS.md` with actual lint/test/dev commands.

## Architecture

```
.claude-plugin/                          # Marketplace manifest (marketplace.json)
plugins/claude-code-blueprint/           # Plugin root
  commands/                              # 25 slash commands (description frontmatter)
  skills/                                # 34 workflow skills (triggered contextually)
  agents/                                # 26 specialized subagents
  hooks/hooks.json                       # Hook definitions (${CLAUDE_PLUGIN_ROOT})
  hooks/handlers/                        # Hook scripts (session-start, context-monitor, etc.)
  templates/                             # Project scaffolding source (copied by /init)
    CLAUDE.md, BACKLOG.md, docs/...      # Template files for new projects
  scripts/ship.sh                        # Ralph-style external loop for /ship
  .claude-plugin/plugin.json             # Plugin manifest
docs/images/                             # README images (repo-only)
install.sh                               # Plugin installer + legacy mode
```

Skills, agents, and commands are self-describing via frontmatter — read their files for when/how to use them.

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

If touching 4+ files, adding new API, or changing data models → use full workflow (`/plan` → `/build`).

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
| `/build` | Between every stage | Single pass (or `--iterate N`) | Features needing human guidance |
| `/ship` | None (fully autonomous) | Iterative (default 3 cycles) | Well-defined features, fire-and-forget |
| `/quick` | None | None | Trivial changes (< 3 files) |

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

See `docs/learnings/LEARNINGS.md` for project-specific patterns, gotchas, and insights. Updated by `/wrap`.
