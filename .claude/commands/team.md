---
description: "Spawn an Agent Team for collaborative multi-file implementation — delegates to a team-lead agent that designs the team, enforces plan approval, coordinates teammates, and optionally reviews + signs off."
argument-hint: "<plan file or task description> [--no-review]"
---

# /team — Collaborative Agent Team

Spawn a team of independent Claude Code instances that coordinate through a shared task list and messaging. A dedicated **team-lead agent** manages the entire lifecycle: designs the team structure, enforces plan approval before coding, monitors progress, resolves blockers, and (unless `--no-review`) reviews the combined output and signs off.

**Announce at start:** "Setting up Agent Team — dispatching team-lead agent."

**Prerequisite:** Agent Teams is an experimental feature. Ensure `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"` is set in your Claude Code settings.json.

## Parse Arguments

- **Plan file or task description:** From `$ARGUMENTS`
- **`--no-review`:** Skip the team-lead's built-in review and sign-off (used when called from `/ship` or `/build`, which handle review themselves)

## Dispatch Team Lead

Dispatch the **team-lead** agent with a full context prompt:

```
Task("team-lead: Execute this plan using TEAM mode (Agent Teams).

Plan file / task: [path or description]
Review mode: [with-review | no-review]
Autonomous mode: [autonomous if called from /ship, supervised otherwise]

Read the plan file completely. Design a team of 3-5 teammates.
Assign file ownership (NO overlap between teammates).
Break work into 5-6 tasks per teammate.
Spawn teammates, enforce plan approval gate, then monitor execution.
After all tasks complete, run tests + build + lint.
[If with-review: Run /review-swarm, fix findings, sign off when P1=0.]
[If no-review: Report execution results only.]

Follow the team-lead agent instructions and agent-teams skill exactly.

CRITICAL: You are the coordinator. Do NOT write code yourself.
If something needs fixing, assign it to a teammate.

Project conventions: docs/context/CONVENTIONS.md
Agent config: blueprint.local.md")
```

## Wait for Team Lead

The team-lead agent runs autonomously in its own 200K context window. When it returns:

1. Read the team-lead's report
2. Present the team performance summary to the user
3. If team-lead signed off (with-review mode): report the sign-off status
4. If team-lead reports blockers: present them and ask the user how to proceed

## Team Lead Responsibilities

The team-lead agent handles all the coordination that the main session previously did:

| Responsibility | What Team Lead Does |
|----------------|--------------------|
| **Team design** | Determines team size, responsibility domains, file ownership |
| **Spawn teammates** | Creates team, spawns each with detailed context prompts |
| **Plan approval gate** | Reviews each teammate's implementation plan before they code |
| **Monitor progress** | Watches task list, intervenes on blockers, relays info |
| **Delegate mode** | Never writes code — creates tasks and assigns to teammates |
| **Integration check** | Runs tests + build + lint after all teammates complete |
| **Review (if enabled)** | Dispatches review-swarm, evaluates findings, creates fix tasks |
| **Sign-off** | Reports APPROVED, APPROVED WITH NOTES, or NOT APPROVED |

## Standalone vs Pipeline Usage

| Context | --no-review | Review happens in |
|---------|-------------|-------------------|
| `/team` (standalone) | No (default) | Team-lead agent reviews + signs off |
| Called from `/ship` | Yes | `/ship` Stage 5 (iterative-refinement) |
| Called from `/ship --swarm` | Yes | `/ship` Stage 5 (parallel review + test) |
| Called from `/build` | Yes | `/build` Stage 5 (review-swarm) |

## When NOT to Use /team

- **Small changes (< 3 files):** Use direct implementation or `/quick`
- **Analysis/review tasks:** Use `/review-swarm` or `/deep-research` (swarm pattern)
- **Strictly sequential work:** Use `/orchestrate` (wave pattern)
- **Single-layer changes:** A single subagent is sufficient
