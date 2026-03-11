# Project Instructions

## Philosophy

**Each unit of engineering work should make subsequent units easier — not harder.**

Quality over speed. Small steps compound into big progress. The patterns you establish will be copied. The corners you cut will be cut again. Fight entropy. Leave the codebase better than you found it.

## Session Continuity

<!-- Updated by /wrap at end of each work session. Read this FIRST when starting a new session. -->

**Last session:** 2026-03-11

**What was done:**
- Fixed `/ship` pipeline's context exhaustion recovery — added missing Stage 0 (state file creation)
- New `scripts/ship.sh` — Ralph-style external bash loop (fresh 200K context per iteration, `--max N`)
- Dual-loop architecture: outer loop (`ship.sh`) for context exhaustion, inner guard (`ship-loop.sh`) for premature exit
- Added `--external` flag to `/ship` — skips Stop hook activation when managed by outer loop
- Added continuation detection to `/ship` Stage 0 — checks git log, plan files, progress file to resume mid-pipeline
- Updated README.md with `/ship` pipeline section, diagram (`ship-pipeline.png`), context management table, pipeline comparison, new commands/skills/agents, updated component counts (24/34/26/5), new FAQ entries
- Re-rendered `project-structure.png` and `agents-ecosystem.png` with updated counts
- Fixed markdownlint MD049 — asterisk emphasis → underscore in CLAUDE.md

**What's remaining:**
- No immediate work remaining — v2.3.0 is fully documented and CI is green
- GOALS.md still has placeholder templates (P3 — filled by `/init` on install)

**Start here:** All v2.3.0 work is complete. Next feature or improvement can be started fresh.

**Current state of the code:**
- Build: n/a (template repo, no build step)
- Tests: CI passing (4/4 jobs green — install ubuntu, install macos, shellcheck, markdownlint)
- Lint: markdownlint clean, shellcheck clean
- Uncommitted changes: none (working tree clean)

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

## Error Handling Philosophy

- Fail loudly at system boundaries; recover gracefully inside
- Log the context needed to reproduce, not just the error message
- Never swallow errors silently — at minimum, log them
- User-facing errors should be helpful; internal errors should be detailed
- If an operation can partially succeed, decide up front: all-or-nothing or best-effort
- Validate inputs at the edges; trust data that's already inside the system

## Task Prioritization

When choosing what to work on next:

1. **Architectural decisions and core abstractions** — get the foundation right
2. **Integration points between modules** — ensure components connect
3. **Unknown unknowns and spike work** — de-risk early
4. **Standard features and implementation** — build on solid foundations
5. **Polish, cleanup, and quick wins** — save easy wins for later

Use micro tasks — smaller the task, better the code. Each task should be completable in one focused session with a clean commit at the end.

## Lightweight Workflow for Small Changes

Not everything needs the full brainstorm → plan → execute flow. Use this shortcut for small, well-understood changes:

**Qualifies as small change:**
- Bug fix with obvious root cause (< 3 files touched)
- Typo, copy, or config fix
- Adding a test for existing behavior
- Renaming or minor refactor within a single module

**Lightweight flow:**
1. Write a failing test (TDD still applies)
2. Fix the issue
3. Verify (run tests, check build)
4. Commit

**Does NOT qualify — use full workflow:**
- Touching 4+ files
- Adding new public API or endpoint
- Changing data models or schemas
- Anything where you're unsure of the approach

When in doubt, use the full workflow. The cost of over-planning is low; the cost of under-planning is rework.

## Deviation Rules — What You Can Auto-Fix vs. Must Ask About

When executing a plan or working autonomously, use these rules to decide whether to fix inline or stop and ask:

**Auto-fix (no permission needed):**
- Wrong queries, logic errors, type errors — fix inline
- Missing error handling, input validation, null checks — add inline
- Missing imports, broken dependencies, incorrect paths — fix inline
- Linting or formatting issues — fix inline
- Typos in code or strings — fix inline

**Must ask the user FIRST:**
- Adding new database tables, columns, or migrations
- Switching frameworks, libraries, or core technologies
- Changing public API contracts or interfaces
- Modifying authentication/authorization logic
- Adding new environment variables or external service dependencies
- Architectural decisions not covered by existing ADRs

**Scope boundary:** Only fix issues directly caused by the current task's changes. Pre-existing issues go in BACKLOG.md, not inline fixes.

## Analysis Paralysis Guard

If you make 5+ consecutive read-only operations (Read, Glob, Grep) without any Edit, Write, or Bash action that modifies state, STOP and either:
1. **Write code** — you have enough information
2. **Report a blocker** — explain what's preventing progress
3. **Ask for help** — the requirements are unclear

Reading is preparation. Writing is progress. Don't confuse the two.

## Error Recovery

When things go wrong during a session:

- **Failed test after code change:** Don't iterate blindly. Use systematic-debugging skill — gather evidence, form hypothesis, test it.
- **Merge conflict:** Read both sides carefully. Understand intent of both changes before resolving. If unclear, ask.
- **Broken build after dependency update:** Pin the previous working version, create a BACKLOG item for the upgrade, and continue with the current task.
- **Corrupted worktree:** Create a fresh worktree from main. Cherry-pick completed commits from the broken one. Don't try to repair in-place.
- **Agent returns unexpected results:** Verify findings manually before acting on them. Agents can hallucinate file paths or misread code.
- **Lost work (uncommitted changes):** Check `git stash list`, `git reflog`, and `git fsck --lost-found` before assuming it's gone.

## Workspace Structure

```
project/
├── .claude/
│   ├── commands/          # Slash commands (24 commands)
│   │   ├── init.md        # /init — interactive project setup
│   │   ├── plan.md        # /plan — brainstorm before building
│   │   ├── build.md       # /build — full-cycle supervised pipeline (with checkpoints)
│   │   ├── ship.md        # /ship — fully autonomous pipeline (zero checkpoints, fire-and-forget)
│   │   ├── deepen.md      # /deepen — enrich a plan with parallel research agents
│   │   ├── discuss.md     # /discuss — capture decisions before planning
│   │   ├── review.md      # /review — code review against standards
│   │   ├── review-swarm.md # /review-swarm — multi-agent parallel review
│   │   ├── deep-research.md # /deep-research — multi-agent parallel research
│   │   ├── compound.md    # /compound — document solved problem for reuse
│   │   ├── orchestrate.md # /orchestrate — wave-based parallel execution
│   │   ├── team.md        # /team — collaborative agent team (experimental)
│   │   ├── status.md      # /status — project state + goal alignment
│   │   ├── debug.md       # /debug [issue] — root cause investigation
│   │   ├── backlog.md     # /backlog — triage capture inbox
│   │   ├── wrap.md        # /wrap — end-of-session documentation
│   │   ├── pr.md          # /pr — create/manage pull requests
│   │   ├── map.md         # /map — analyze unfamiliar codebase
│   │   ├── resume.md      # /resume — reload context from last session
│   │   ├── pause.md       # /pause — mid-session checkpoint
│   │   ├── quick.md       # /quick — fast-track small changes with TDD
│   │   ├── changelog.md   # /changelog — generate release notes
│   │   ├── add-tests.md   # /add-tests — find and fill test gaps
│   │   └── health.md      # /health — comprehensive project health check
│   ├── hooks/             # Lifecycle hooks
│   │   ├── session-start.js   # Bootstrap context on session start
│   │   ├── context-monitor.js # Track context usage + analysis paralysis guard
│   │   ├── teammate-idle.js   # Agent Teams: quality gate when teammate finishes
│   │   ├── task-completed.js  # Agent Teams: quality gate on task completion
│   │   └── ship-loop.sh       # Stop hook: Ralph-style session iteration for /ship
│   ├── skills/            # Workflow skills (34 skills)
│   │   ├── brainstorming/
│   │   ├── writing-plans/
│   │   ├── executing-plans/
│   │   ├── test-driven-development/
│   │   ├── systematic-debugging/
│   │   ├── verification-before-completion/
│   │   ├── requesting-code-review/
│   │   ├── receiving-code-review/
│   │   ├── subagent-driven-development/
│   │   ├── dispatching-parallel-agents/
│   │   ├── finishing-a-development-branch/
│   │   ├── using-git-worktrees/
│   │   ├── writing-skills/
│   │   ├── session-wrap/
│   │   ├── codebase-mapping/
│   │   ├── context-checkpoint/
│   │   ├── pr-workflow/
│   │   ├── resolve-in-parallel/
│   │   ├── deployment-verification/
│   │   ├── document-review/
│   │   ├── changelog-generation/
│   │   ├── migration-planning/
│   │   ├── performance-profiling/
│   │   ├── browser-testing/
│   │   ├── autonomous-loop/
│   │   ├── iterative-refinement/
│   │   ├── wave-orchestration/
│   │   ├── swarm-orchestration/
│   │   ├── agent-teams/
│   │   ├── knowledge-compounding/
│   │   ├── session-continuity/
│   │   ├── dependency-management/
│   │   ├── spike-exploration/
│   │   └── scope-cutting/
│   └── agents/            # Specialized subagents (26 agents, dispatched via Task tool)
│       ├── code-reviewer.md
│       ├── architecture-strategist.md
│       ├── security-sentinel.md
│       ├── code-simplicity-reviewer.md
│       ├── performance-oracle.md
│       ├── best-practices-researcher.md
│       ├── git-history-analyzer.md
│       ├── learnings-researcher.md
│       ├── plan-checker.md
│       ├── integration-checker.md
│       ├── bug-reproduction-validator.md
│       ├── codebase-mapper.md
│       ├── pr-comment-resolver.md
│       ├── test-gap-analyzer.md
│       ├── research-synthesizer.md
│       ├── deployment-verifier.md
│       ├── schema-drift-detector.md
│       ├── frontend-reviewer.md
│       ├── convention-enforcer.md
│       ├── data-integrity-guardian.md
│       ├── test-coverage-reviewer.md
│       ├── framework-docs-researcher.md
│       ├── codebase-context-mapper.md
│       ├── integration-verifier.md
│       ├── findings-synthesizer.md
│       └── team-lead.md
├── .claude-plugin/
│   └── plugin.json        # Plugin manifest for marketplace distribution
├── blueprint.local.md    # Per-project agent config (gitignored)
├── docs/
│   ├── decisions/         # Architecture Decision Records (ADRs)
│   ├── plans/             # Implementation plans (YYYY-MM-DD-topic.md)
│   ├── specs/             # Feature specs and requirements
│   ├── research/          # Domain research and analysis
│   ├── solutions/         # Solved problems — institutional knowledge (created by /compound)
│   └── context/           # Project goals, status, conventions
│       ├── GOALS.md       # Objectives + priority framework
│       ├── STATUS.md      # Commit log, current state, known issues
│       ├── CONVENTIONS.md # Tech stack, coding standards, boundaries
│       └── DECISIONS.md   # Locked decisions from /discuss (created on demand)
├── src/                   # Application source code
├── tests/                 # Test suite
├── infra/                 # Docker, CI/CD, deployment configs
├── scripts/               # Automation and utility scripts
├── BACKLOG.md             # Quick capture inbox
├── CLAUDE.md              # This file — agent instructions
└── README.md              # Project README
```

## Code Quality Standards

- Keep files under 500 lines — split if longer
- Use typed interfaces for all public APIs
- Write tests FIRST — follow the test-driven-development skill (red-green-refactor)
- DRY, YAGNI — remove dead code, don't add features beyond what's asked
- Run linter and tests before every commit — never commit red
- One logical change per commit — if you need "and" to describe it, split it
- No TODO comments without a corresponding BACKLOG.md entry
- No commented-out code — delete it, git remembers

## Context Loading

When starting a session, context loads in this order:

1. **SessionStart hook** — bootstraps project state summary automatically
2. **CLAUDE.md** (this file) — always loaded, includes Session Continuity
3. **docs/context/STATUS.md** — read for full project state, commit history, known issues
4. **docs/context/GOALS.md** — read when prioritizing work or triaging backlog
5. **docs/context/CONVENTIONS.md** — read before writing code (tech stack, naming, patterns)
6. **docs/context/DECISIONS.md** — locked decisions that MUST be honored (created by `/discuss`)
7. **BACKLOG.md** — read when looking for what to work on next
8. **docs/solutions/** — searched by learnings-researcher before planning (institutional knowledge)
9. **blueprint.local.md** — per-project agent configuration (which reviewers/researchers to use)
10. **.claude/skills/** — triggered contextually or invoked via commands
11. **.claude/agents/** — dispatched via Task tool for isolated 200K-context work

The Session Continuity section above tells you where to start. If it's empty, run `/init` to set up the project or `/status` to orient.

## Skills — When They Trigger

| Situation | Skill | Command |
|-----------|-------|---------|
| Full-cycle supervised development | (chains all below) | `/build` |
| Full-cycle autonomous development | (chains all below, zero checkpoints) | `/ship` |
| Enrich a plan with parallel research | (plan deepening) | `/deepen` |
| Capture decisions before planning | (discuss process) | `/discuss` |
| Before building anything new | brainstorming | `/plan` |
| Have approved design, need steps | writing-plans | — |
| Executing a multi-step plan | executing-plans | — |
| Writing any new code or fixing bugs | test-driven-development | — |
| Encountering a bug or test failure | systematic-debugging | `/debug` |
| About to claim work is done | verification-before-completion | — |
| Completing a task, before merging | requesting-code-review | `/review` |
| Receiving review feedback | receiving-code-review | — |
| Multiple independent tasks | dispatching-parallel-agents | — |
| Executing plan tasks in session | subagent-driven-development | — |
| Need isolated workspace | using-git-worktrees | — |
| Implementation complete, integrate | finishing-a-development-branch | — |
| Creating or editing skills | writing-skills | — |
| End of work session | session-wrap | `/wrap` |
| Small bug fix or config change | (lightweight flow — see above) | `/quick` |
| Exploratory spike or research | spike-exploration | — |
| Onboarding to unfamiliar codebase | codebase-mapping | `/map` |
| Mid-session state capture | context-checkpoint | `/pause` |
| Creating or managing pull requests | pr-workflow | `/pr` |
| Batch-resolving independent items | resolve-in-parallel | — |
| Pre-production deployment check | deployment-verification | — |
| Reviewing specs, plans, or docs | document-review | — |
| Generating release notes | changelog-generation | `/changelog` |
| Planning database or API migrations | migration-planning | — |
| Investigating performance issues | performance-profiling | — |
| Verifying UI in a real browser | browser-testing | — |
| Autonomous plan execution with retry | autonomous-loop (with circuit breaker) | — |
| Iterative review→fix→review cycles | iterative-refinement | — |
| Plan with mixed dependencies, parallel+serial | wave-orchestration | `/orchestrate` |
| Dispatching multiple agents on same problem | swarm-orchestration | `/review-swarm`, `/deep-research` |
| Collaborative multi-file implementation | agent-teams | `/team` |
| Documenting a solved problem for reuse | knowledge-compounding | `/compound` |
| Tracking state across session boundaries | session-continuity | `/pause`, `/resume` |
| Adding, upgrading, or removing dependencies | dependency-management | — |
| Feature too large, need to reduce scope | scope-cutting | — |

## Agents — When to Dispatch

Use Task tool to dispatch agents when you need isolated 200K context for a specific job:

| Agent | When to Use |
|-------|-------------|
| code-reviewer | After completing a major step — reviews diff against plan and standards |
| architecture-strategist | Reviewing structural changes, adding services, evaluating refactors |
| security-sentinel | Before deployment, after implementing auth/payment/API endpoints |
| code-simplicity-reviewer | After implementation — identifies YAGNI violations and over-engineering |
| performance-oracle | After features are built — finds bottlenecks, N+1 queries, scaling issues |
| best-practices-researcher | Need industry standards or implementation guidance for a technology |
| git-history-analyzer | Need to understand why code evolved to its current state |
| learnings-researcher | Before planning — searches docs/ for past solutions, decisions, and patterns |
| plan-checker | After writing a plan — verifies it will work before execution begins |
| integration-checker | After implementation — verifies components are wired together correctly |
| bug-reproduction-validator | When debugging — validates reproduction steps and verifies fixes work |
| codebase-mapper | Onboarding to unfamiliar code — maps architecture, conventions, stack, concerns |
| pr-comment-resolver | Processing PR feedback — resolves a single review comment with minimal change |
| test-gap-analyzer | Improving coverage — finds untested paths and generates behavioral tests |
| research-synthesizer | After parallel research — consolidates multiple agent outputs into unified summary |
| deployment-verifier | Before deploying — verifies build, tests, security, migrations, rollback plan |
| schema-drift-detector | Reviewing PRs — catches unrelated schema/migration changes in diffs |
| frontend-reviewer | Reviewing UI code — checks a11y, responsive, CSS perf, component architecture |
| convention-enforcer | Reviewing code — validates changes against CONVENTIONS.md rules |
| data-integrity-guardian | PRs with migrations, schema changes, or data transformations |
| test-coverage-reviewer | After implementation — verifies test quality, not just line coverage |
| framework-docs-researcher | Before planning — gathers current docs for frameworks used in project |
| codebase-context-mapper | Before planning — maps files and dependencies affected by a specific change |
| integration-verifier | After wave completion — verifies parallel implementations work together |
| findings-synthesizer | After review/research swarm — de-duplicates and prioritizes all findings |
| team-lead | Orchestrates /orchestrate and /team — delegates to workers, monitors, reviews, signs off |

## Multi-Agent Patterns

Four orchestration patterns for coordinated multi-agent workflows:

```
Controller (main Claude session)
│
├── Research Swarm (/deep-research) ── all run in parallel
│   ├── best-practices-researcher
│   ├── framework-docs-researcher
│   ├── learnings-researcher
│   ├── git-history-analyzer
│   ├── codebase-context-mapper
│   └── → research-synthesizer (sequential, after all above)
│
├── Planning Pipeline (sequential)
│   ├── plan-checker (loop: verify → fix → re-verify, max 3 passes)
│   ├── /deepen (parallel research enrichment)
│   └── integration-checker
│
├── Execution — team-lead agent orchestrates (choose one mode):
│   │
│   ├── team-lead (dedicated 200K context, delegates all work)
│   │   ├── Designs execution strategy
│   │   ├── Dispatches and monitors workers
│   │   ├── Runs integration verification
│   │   ├── Reviews + signs off (standalone) or reports (pipeline --no-review)
│   │   │
│   │   ├── Wave Mode (/orchestrate)
│   │   │   ├── Wave 1: [implementer-A, implementer-B] (parallel, worktree-isolated)
│   │   │   ├── integration-verifier (between each wave)
│   │   │   └── Wave 2: [implementer-C] (depends on Wave 1)
│   │   │
│   │   └── Team Mode (/team)
│   │       ├── Plan approval gate (each teammate submits plan before coding)
│   │       ├── Teammate A (owns src/api/*) ──┐
│   │       ├── Teammate B (owns src/ui/*)    ├── shared task list + messaging
│   │       ├── Teammate C (owns tests/*)   ──┘
│   │       └── Quality gates: TeammateIdle + TaskCompleted hooks
│
├── Iterative Review (/ship, /build --iterate N)
│   ├── iteration 1: /review-swarm → findings → resolve-in-parallel → test
│   ├── iteration 2: /review-swarm → findings → resolve-in-parallel → test
│   ├── ... (converges when P1 = 0 or max iterations reached)
│   └── Circuit breaker: stops on no-progress or repeated errors
│
├── Review Swarm (/review-swarm) ── all run in parallel
│   ├── code-reviewer
│   ├── security-sentinel
│   ├── performance-oracle
│   ├── code-simplicity-reviewer
│   ├── convention-enforcer
│   ├── test-coverage-reviewer
│   ├── + conditional: architecture-strategist, frontend-reviewer,
│   │     data-integrity-guardian, schema-drift-detector
│   └── → findings-synthesizer (sequential, after all above)
│
└── Knowledge Loop
    └── /compound → docs/solutions/ → learnings-researcher → /plan
```

**Choosing an execution pattern:**

| Pattern | Use When | Key Feature |
|---------|----------|-------------|
| **Waves** (`/orchestrate`) | Tasks have dependency ordering | Worktree isolation + integration verification |
| **Agent Teams** (`/team`) | Teammates need to discuss and coordinate | Shared task list + messaging + plan approval gate |
| **Sequential** | All tasks are dependent | Autonomous loop (with circuit breaker) |

**Choosing a pipeline:**

| Pipeline | Checkpoints | Review | Best For |
|----------|-------------|--------|----------|
| `/build` | Between every stage | Single pass (or `--iterate N`) | Features needing human guidance |
| `/ship` | None (fully autonomous) | Iterative (default 3 cycles) | Well-defined features, fire-and-forget |
| `/quick` | None | None | Trivial changes (< 3 files) |

**Per-project config:** Edit `blueprint.local.md` to enable/disable agents for your stack.

## Commit Conventions

One logical change per commit. Format: `type(scope): brief description`

Types:
- `feat:` new feature
- `fix:` bug fix
- `refactor:` code restructuring (no behavior change)
- `docs:` documentation changes
- `test:` test additions/changes
- `chore:` maintenance tasks (deps, configs, CI)
- `style:` formatting only (no logic change)
- `perf:` performance improvement

Scope is optional but encouraged: `feat(auth): add JWT refresh token rotation`

## Key Learnings

_Append dated entries here as the project evolves. This section is the project's institutional memory. Updated by `/wrap`._

### 2026-03-04: Block-beta diagrams — arrows cause phantom rows, use color for hierarchy
Removing arrows from `block-beta` Mermaid diagrams eliminates the phantom routing rows that made diagrams visually cluttered. Instead, use dark section headers (#2C3E50, white text) paired with light child nodes to create clear visual containment without needing connectors or subgraph nesting. This dark/light contrast pattern should be used for all future block-beta diagrams in the template.

### 2026-03-05: Gap analysis across 5 repos shaped the skill/agent expansion
Researched ruflo, compound-engineering, superpowers, get-shit-done, and ralphy repos to identify missing capabilities. Key patterns adopted: autonomous retry loop with exponential backoff (ralphy), structured document review with three-pass critique, deployment verification checklists, and parallel resolution of independent items. Multi-engine orchestration (ralphy) was explicitly excluded as out of scope for a Claude-focused template.

### 2026-03-09: HTML/CSS diagrams via Playwright beat Mermaid for quality
Switching from Mermaid block-beta → HTML/CSS rendered via Playwright `element.screenshot()` produces dramatically better diagrams: proper Inter/JetBrains Mono fonts, flexbox layout, gradient badges, and full color control. Source is `docs/images/render-diagrams.html`. Mermaid `.mmd` files kept for reference but are no longer the primary rendering path. Also: `background-clip: text` CSS gradient breaks in Chromium PDF — use solid color instead.

### 2026-03-09: Agent swarm architecture — three orchestration patterns
After evaluating 8 Claude Code repos, three multi-agent patterns emerged: (1) **Swarm** — N specialists analyze same input in parallel, synthesizer merges findings (used for review and research); (2) **Wave** — tasks grouped by dependency, parallel within waves, integration-verifier between waves; (3) **Knowledge loop** — `/compound` saves solved problems to `docs/solutions/`, learnings-researcher searches them before future planning. Per-project config (`blueprint.local.md`) prevents irrelevant agents from wasting tokens. Compound Engineering's parallel review was the gold standard; GSD's context monitoring was already in our hooks.

### 2026-03-09: CI install tests should use threshold counts, not exact
Testing `>=20 commands` instead of `==21` means adding new components doesn't break CI. The install script tests on both ubuntu and macos to catch platform-specific issues (e.g., `find` flag differences, `wc` whitespace handling). ShellCheck SC2295: parameter expansions inside `${..#..}` need inner quotes to prevent glob pattern matching — `"${dest#"$TARGET_DIR"/}"` not `"${dest#$TARGET_DIR/}"`.

### 2026-03-09: Agent tool restrictions — principle of least privilege from official docs
Official Claude Code docs recommend "grant only necessary permissions" via the `tools` frontmatter field. Three tiers emerged: (1) review/verification agents get `[Read, Glob, Grep, Bash]` — read-only analysis; (2) web researchers add `WebFetch, WebSearch`; (3) only 3 agents that must modify code get `Edit, Write`. Synthesizers need only `[Read, Glob, Grep]` — no Bash, no web. This prevents accidental writes during analysis and makes agent intent explicit in the frontmatter.

### 2026-03-09: Agent Teams complement swarms — don't replace them
Anthropic's experimental Agent Teams feature (shared task list + messaging between independent Claude instances) serves a different purpose than subagent swarms. Swarms are best for parallel read-only analysis; Agent Teams for collaborative implementation where teammates need to discuss and divide file ownership. The template integrates both: `/deep-research` (swarm) → `/plan` → `/team` OR `/orchestrate` → `/review-swarm` (swarm). Key requirement: each teammate MUST own specific files — concurrent modification causes conflicts. Quality gate hooks (`TeammateIdle`, `TaskCompleted`) enforce standards. Use `execFileSync` not `execSync` in template hooks to prevent shell injection.

### 2026-03-11: Three iteration layers compose naturally — task, quality, session
The template now has three distinct iteration mechanisms at different granularities: (1) **Task-level** (`autonomous-loop` + circuit breaker) — retry individual tasks with exponential backoff, stop on stalls; (2) **Quality-level** (`iterative-refinement`) — review→fix→review N times, converge on P1=0; (3) **Session-level** (`ship-loop.sh` Stop hook) — Ralph-style re-feed of prompt when context exhausts. They compose within `/ship`: autonomous loop executes tasks, iterative refinement polishes output, Stop hook restarts if the session runs out of context before `<promise>DONE</promise>`.

### 2026-03-11: Team-lead agent + --no-review flag enables composable execution
Dedicating a team-lead agent (fresh 200K context) to coordinate `/orchestrate` and `/team` solves two problems: (1) the main session's context isn't consumed by coordination overhead, and (2) standalone execution commands self-review and sign off, while pipeline commands (`/ship`, `/build`) pass `--no-review` to avoid double review. This composability pattern — inner components controllable by outer pipelines — is how CE's `disable-model-invocation` works, adapted for project-level commands without plugin infrastructure.

### 2026-03-11: GSD's plan-checker verify loop is the highest-ROI quality gate
Researching GSD, Ralph, and CE revealed that validating plans _before_ execution catches the most expensive mistakes earliest. `/ship` now runs a plan-checker → fix → re-check loop (max 3 passes) before committing to execution. Fixing a wrong approach in a markdown plan costs seconds; fixing it after implementation costs minutes of rework + debugging + re-review. This is combined with `/deepen` (parallel research enrichment) to produce plans that are both validated and deeply informed.

### 2026-03-11: Stop hook "decision: block" does NOT reset context — use external bash loop for that
Ralph (`ralph.sh`) spawns a fresh `claude --print` process per iteration in a bash for-loop — each gets clean 200K context. Our `ship-loop.sh` Stop hook uses `"decision": "block"` which prevents exit but continues the same session (context keeps growing). These solve different problems: the Stop hook catches premature exit (Claude gives up too early), while the external loop handles genuine context exhaustion. The `--external` flag in `/ship` disables the Stop hook when the outer loop manages restarts, preventing conflict between the two mechanisms.
