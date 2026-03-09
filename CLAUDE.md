# Project Instructions

## Philosophy

**Each unit of engineering work should make subsequent units easier — not harder.**

Quality over speed. Small steps compound into big progress. The patterns you establish will be copied. The corners you cut will be cut again. Fight entropy. Leave the codebase better than you found it.

## Session Continuity

<!-- Updated by /wrap at end of each work session. Read this FIRST when starting a new session. -->

**Last session:** 2026-03-09

**What was done:**
- Added Claude Code plugin ecosystem ebook (`ebook/claude-code-tools-guide.pdf`) and README section linking to it (`7a242a5`)
- Redesigned all 5 README diagrams from HTML/CSS source via Playwright screenshots (`98a9fa0`): workflow, quality-gates, skills-map, agents-ecosystem, project-structure
- Updated hero banner SVG with correct counts: 25 Skills, 17 Commands, 19 Agents
- Fixed ASCII art in README: development loop and agent dispatch diagrams
- Added `docs/images/render-diagrams.html` as reproducible source for PNG generation

**What's remaining:**
- Add GitHub Actions CI (lint markdown, test install script)
- Add `--version` flag or release tagging strategy to install.sh
- Expand example docs with more variety
- Consider adding skills: dependency management, spike/exploration, scope cutting

**Start here:** All diagrams are updated and pushed. The ebook PDF evaluating 8 Claude Code tools is in `ebook/`. Next work should focus on CI setup or remaining skill gaps. Run `/status` to orient.

**Current state of the code:**
- Build: n/a (template repo, no build step)
- Tests: n/a (install.sh tested manually via dry-run)
- Uncommitted changes: none — working tree clean

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
│   ├── commands/          # Slash commands (17 commands)
│   │   ├── init.md        # /init — interactive project setup
│   │   ├── plan.md        # /plan — brainstorm before building
│   │   ├── build.md       # /build — full-cycle autonomous pipeline
│   │   ├── discuss.md     # /discuss — capture decisions before planning
│   │   ├── review.md      # /review — code review against standards
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
│   │   └── context-monitor.js # Track context usage + analysis paralysis guard
│   ├── skills/            # Workflow skills (25 skills)
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
│   │   └── autonomous-loop/
│   └── agents/            # Specialized subagents (19 agents, dispatched via Task tool)
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
│       └── convention-enforcer.md
├── .claude-plugin/
│   └── plugin.json        # Plugin manifest for marketplace distribution
├── docs/
│   ├── decisions/         # Architecture Decision Records (ADRs)
│   ├── plans/             # Implementation plans (YYYY-MM-DD-topic.md)
│   ├── specs/             # Feature specs and requirements
│   ├── research/          # Domain research and analysis
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
8. **.claude/skills/** — triggered contextually or invoked via commands
9. **.claude/agents/** — dispatched via Task tool for isolated 200K-context work

The Session Continuity section above tells you where to start. If it's empty, run `/init` to set up the project or `/status` to orient.

## Skills — When They Trigger

| Situation | Skill | Command |
|-----------|-------|---------|
| Full-cycle feature development | (chains all below) | `/build` |
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
| Exploratory spike or research | best-practices-researcher agent + `docs/research/` | — |
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
| Autonomous plan execution with retry | autonomous-loop | — |

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
