---
description: "Execute a plan using wave-based parallel orchestration — delegates to a team-lead agent that groups tasks by dependencies, dispatches parallel workers, verifies integration, and optionally reviews + signs off."
argument-hint: "[path to plan file] [--no-review] [--iterations N] [--convergence fast|deep|perfect]"
---

# /orchestrate — Wave-Based Parallel Execution

Execute a plan using dependency-aware wave orchestration. A dedicated **team-lead agent** coordinates the entire process: groups tasks into waves, dispatches parallel workers in worktree-isolated subagents, runs integration verification between waves, and (unless `--no-review`) reviews the combined output and signs off.

**Announce at start:** "Starting wave orchestration — dispatching team-lead agent."

## Parse Arguments

- **Plan file:** Path from `$ARGUMENTS` (if not provided, look for the most recent plan in `docs/plans/`)
- **`--no-review`:** Skip the team-lead's built-in review and sign-off (used when called from `/ship` or `/build`, which handle review themselves)
- **`--iterations N`:** Max review-improve iterations (default: 1 = single pass, max: 10). When > 1, team-lead uses iterative-refinement skill instead of single review-swarm pass.
- **`--convergence fast|deep|perfect`:** Review convergence mode (default: `fast`). `fast` = exit when P1=0, `deep` = exit when P1+P2=0, `perfect` = exit when all findings=0. Only applies when `--iterations` > 1.

## Dispatch Team Lead

Dispatch the **team-lead** agent with a full context prompt:

```
Task("team-lead: Execute this plan using WAVE mode.

Plan file: [path to plan file]
Review mode: [with-review | no-review]
Review iterations: [N] (default 1)
Review convergence: [fast|deep|perfect] (default fast)
Autonomous mode: [autonomous if called from /ship, supervised otherwise]

Read the plan file completely. Group tasks into dependency-ordered waves.
For each wave, dispatch parallel subagents with worktree isolation.
Run integration-verifier between waves.
After all waves complete, run tests + build + lint.
[If no-review: Report execution results only.]
[If with-review AND iterations=1: Run /review-swarm, fix P1 findings, sign off.]
[If with-review AND iterations>1: Run iterative-refinement skill with max_iterations=[N] and convergence=[mode]. Sign off when converged.]

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
| `/orchestrate` (standalone) | No (default) | Team-lead: single review-swarm pass |
| `/orchestrate --iterations 5` | No | Team-lead: iterative-refinement (up to 5 cycles) |
| `/orchestrate --iterations 5 --convergence deep` | No | Team-lead: iterative-refinement (exit when P1+P2=0) |
| Called from `/ship` | Yes | `/ship` Stage 5 (iterative-refinement) |
| Called from `/build` | Yes | `/build` Stage 5 (review-swarm) |

When called standalone, `/orchestrate` is **self-contained**: execution + review + sign-off, all handled by the team-lead agent. When called from a pipeline, the pipeline handles review to avoid double work.
