---
description: "Execute a plan using wave-based parallel orchestration — delegates to a team-lead agent that groups tasks by dependencies, dispatches parallel workers, verifies integration, and optionally reviews + signs off."
argument-hint: "[path to plan file] [--no-review]"
---

# /orchestrate — Wave-Based Parallel Execution

Execute a plan using dependency-aware wave orchestration. A dedicated **team-lead agent** coordinates the entire process: groups tasks into waves, dispatches parallel workers in worktree-isolated subagents, runs integration verification between waves, and (unless `--no-review`) reviews the combined output and signs off.

**Announce at start:** "Starting wave orchestration — dispatching team-lead agent."

## Parse Arguments

- **Plan file:** Path from `$ARGUMENTS` (if not provided, look for the most recent plan in `docs/plans/`)
- **`--no-review`:** Skip the team-lead's built-in review and sign-off (used when called from `/ship` or `/build`, which handle review themselves)

## Dispatch Team Lead

Dispatch the **team-lead** agent with a full context prompt:

```
Task("team-lead: Execute this plan using WAVE mode.

Plan file: [path to plan file]
Review mode: [with-review | no-review]
Autonomous mode: [autonomous if called from /ship, supervised otherwise]

Read the plan file completely. Group tasks into dependency-ordered waves.
For each wave, dispatch parallel subagents with worktree isolation.
Run integration-verifier between waves.
After all waves complete, run tests + build + lint.
[If with-review: Run /review-swarm, fix findings, sign off when P1=0.]
[If no-review: Report execution results only.]

Follow the team-lead agent instructions and wave-orchestration skill exactly.

Project conventions: docs/context/CONVENTIONS.md
Agent config: blueprint.local.md")
```

## Wait for Team Lead

The team-lead agent runs autonomously in its own 200K context window. When it returns:

1. Read the team-lead's report
2. Present the execution summary to the user
3. If team-lead signed off (with-review mode): report the sign-off status
4. If team-lead reports blockers: present them and ask the user how to proceed

## Standalone vs Pipeline Usage

| Context | --no-review | Review happens in |
|---------|-------------|-------------------|
| `/orchestrate` (standalone) | No (default) | Team-lead agent reviews + signs off |
| Called from `/ship` | Yes | `/ship` Stage 5 (iterative-refinement) |
| Called from `/build` | Yes | `/build` Stage 5 (review-swarm) |

When called standalone, `/orchestrate` is **self-contained**: execution + review + sign-off, all handled by the team-lead agent. When called from a pipeline, the pipeline handles review to avoid double work.
