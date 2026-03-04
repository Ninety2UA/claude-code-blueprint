# Project Instructions

## Philosophy

**Each unit of engineering work should make subsequent units easier — not harder.**

Quality over speed. Small steps compound into big progress. The patterns you establish will be copied. The corners you cut will be cut again. Fight entropy. Leave the codebase better than you found it.

## Session Continuity

<!-- Updated by /wrap at end of each work session. Read this FIRST when starting a new session. -->

**Last session:** 2026-03-04

**What was done:**
- Created complete GitHub repository from ZIP template (https://github.com/Ninety2UA/claude-code-blueprint)
- Wrote comprehensive README.md (450+ lines) with hero banner SVG, 5 Mermaid diagrams rendered to SVG, full reference tables, FAQ
- Created install.sh — one-line installer with `--claude-only`, `--docs-only`, `--no-overwrite`, `--dry-run`, `--force` options
- Added LICENSE (MIT), CONTRIBUTING.md
- Applied review findings: populated settings.json, added 4 example docs (ADR, plan, spec, research), added lightweight workflow for small changes, added error recovery guidance, added worktree cleanup to session-wrap, added brainstorming escape hatch for trivial fixes
- Verified install script works end-to-end from live GitHub URL

**What's remaining:**
- Consider adding more skills (dependency management, spike/exploration, scope cutting)
- Add GitHub Actions CI to validate template (lint markdown, test install script)
- Consider a `--version` flag or release tagging strategy
- The example docs can be expanded with more variety

**Start here:** The template is deployed and functional. Next work should focus on expanding skills or adding CI. Run `/status` to orient.

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
│   ├── commands/          # Slash commands
│   │   ├── init.md        # /init — interactive project setup
│   │   ├── plan.md        # /plan — brainstorm before building
│   │   ├── review.md      # /review — code review against standards
│   │   ├── status.md      # /status — project state + goal alignment
│   │   ├── debug.md       # /debug [issue] — root cause investigation
│   │   ├── backlog.md     # /backlog — triage capture inbox
│   │   └── wrap.md        # /wrap — end-of-session documentation
│   ├── skills/            # Workflow skills (14+ skills)
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
│   │   └── session-wrap/
│   └── agents/            # Specialized subagents (dispatched via Task tool)
│       ├── code-reviewer.md
│       ├── architecture-strategist.md
│       ├── security-sentinel.md
│       ├── code-simplicity-reviewer.md
│       ├── performance-oracle.md
│       ├── best-practices-researcher.md
│       └── git-history-analyzer.md
├── docs/
│   ├── decisions/         # Architecture Decision Records (ADRs)
│   ├── plans/             # Implementation plans (YYYY-MM-DD-topic.md)
│   ├── specs/             # Feature specs and requirements
│   ├── research/          # Domain research and analysis
│   └── context/           # Project goals, status, conventions
│       ├── GOALS.md       # Objectives + priority framework
│       ├── STATUS.md      # Commit log, current state, known issues
│       └── CONVENTIONS.md # Tech stack, coding standards, boundaries
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

1. **CLAUDE.md** (this file) — always loaded, includes Session Continuity
2. **docs/context/STATUS.md** — read for full project state, commit history, known issues
3. **docs/context/GOALS.md** — read when prioritizing work or triaging backlog
4. **docs/context/CONVENTIONS.md** — read before writing code (tech stack, naming, patterns)
5. **BACKLOG.md** — read when looking for what to work on next
6. **.claude/skills/** — triggered contextually or invoked via commands
7. **.claude/agents/** — dispatched via Task tool for isolated 200K-context work

The Session Continuity section above tells you where to start. If it's empty, run `/init` to set up the project or `/status` to orient.

## Skills — When They Trigger

| Situation | Skill | Command |
|-----------|-------|---------|
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
| Small bug fix or config change | (lightweight flow — see above) | — |
| Exploratory spike or research | best-practices-researcher agent + `docs/research/` | — |

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

_Append dated entries here as the project evolves. This section is the project's institutional memory. Updated by /wrap._

### 2026-03-04: Initial template creation and review findings
Created the full template repo from a ZIP source. Key design decisions: (1) SVG diagrams for README rendered from Mermaid .mmd sources via `mmdc` — keep both in repo so diagrams can be regenerated. (2) Install script excludes `docs/images/` (SVGs are only for GitHub README display, not needed in user projects). (3) Example docs are clearly marked as examples with deletion guidance — this was a critical gap since first-time users had no reference for document format. (4) Lightweight workflow exception added to brainstorming skill — not everything needs full brainstorm→plan flow. The boundary is clear: < 3 files + obvious fix = lightweight; 4+ files or unclear approach = full workflow.
