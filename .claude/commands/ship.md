---
description: "Fully autonomous development pipeline — zero checkpoints, plans through execution through iterative review to PR. Fire and forget."
argument-hint: "<feature description> [--swarm] [--iterations N] [--convergence fast|deep|perfect] [--external]"
---

# /ship — Autonomous End-to-End Pipeline

You are executing the fully autonomous development pipeline. Unlike `/build` (which stops for user approval between stages), `/ship` runs to completion with NO checkpoints. Every decision is made autonomously.

**Announce at start:** "Starting /ship — fully autonomous pipeline. No checkpoints. Will deliver a PR when done."

## Parse Arguments

Extract from `$ARGUMENTS`:
- **Feature description:** Everything that isn't a flag
- **`--swarm`:** Enable parallel work execution via `/team` with swarm-style task dispatch (default: off, use `/orchestrate`)
- **`--iterations N`:** Max review-improve iterations (default: 3, max: 10)
- **`--convergence fast|deep|perfect`:** Review convergence mode (default: fast)
- **`--external`:** Set by `scripts/ship.sh` — signals this session is managed by the external loop (skip Stop hook activation)

## Pipeline Stages

Execute ALL stages sequentially. Do NOT stop for user input. Make all decisions autonomously.

---

### Stage 0: Initialize Loop & Detect Continuation

Two loop mechanisms exist — the external bash loop (`scripts/ship.sh`) and the internal Stop hook (`ship-loop.sh`). Stage 0 handles both.

#### Continuation detection (both modes)

Check if this is a continuation of a previous `/ship` run:

1. Check git log on current branch for prior commits from this pipeline
2. Check if a plan file already exists in `docs/plans/` for this feature
3. Check for uncommitted changes
4. Check if `.claude/ship-progress.local.md` exists (external loop progress file)

If continuation detected, **skip to the stage that needs work** — don't redo requirements, planning, or deepening if those artifacts already exist on disk.

#### External mode (`--external` flag is set)

The external `scripts/ship.sh` bash loop manages context-exhaustion restarts by spawning fresh Claude processes. Do NOT create the Stop hook state file — the external loop handles iteration.

Continue to Stage 1 (or resume from detected progress).

#### Interactive mode (`--external` flag is NOT set)

Create the Stop hook state file to guard against premature exit within this session. Write `.claude/ship-loop.local.md`:

```yaml
---
active: true
session_id: "<current-branch-name>"
iteration: 1
max_iterations: 5
completion_promise: "DONE"
---
<paste the full original feature description from $ARGUMENTS here, including all flags>
```

- `max_iterations: 5` caps inner restarts to prevent infinite blocking if context is exhausted
- The session_id uses the branch name so other sessions aren't blocked
- If this file already exists with `iteration` > 1, you are in a **continuation session** from a prior Stop hook restart

---

### Stage 1: Requirements (Auto-Discuss)

Analyze the feature description. If requirements are clear and unambiguous:
- Lock them as decisions
- Skip to Stage 2

If requirements are ambiguous:
- Make reasonable assumptions based on project context (read `docs/context/CONVENTIONS.md`, `docs/context/GOALS.md`)
- Document assumptions as locked decisions
- Proceed — do NOT ask the user

Write locked decisions to `docs/context/DECISIONS.md` (append, don't overwrite).

---

### Stage 2: Plan

#### 2a. Parallel Research

Dispatch these agents simultaneously:
- **learnings-researcher** — search `docs/solutions/` for relevant prior work
- **framework-docs-researcher** — gather current docs for frameworks involved
- **codebase-context-mapper** — map files and dependencies affected by this change

Collect all research results.

#### 2b. Write Plan

Read and follow the writing-plans skill in `.claude/skills/writing-plans/SKILL.md`. Incorporate all research findings into the plan. Write the plan to `docs/plans/YYYY-MM-DD-<topic>.md`.

#### 2c. Plan Verification Loop

Dispatch the **plan-checker** agent to verify the plan. If the plan-checker reports BLOCKING issues:

```
for pass in 1..3:
    Fix blocking issues in the plan
    Re-dispatch plan-checker
    if no BLOCKING issues: break
```

If blocking issues persist after 3 passes, STOP the pipeline and report: "Plan verification failed after 3 passes. Remaining blockers: [list]. Run `/build` for supervised planning."

---

### Stage 3: Deepen Plan

Read and invoke `.claude/commands/deepen.md` on the plan file. This enriches the plan with parallel research from all configured research agents.

---

### Stage 4: Execute

Both modes dispatch a dedicated **team-lead agent** that coordinates all execution in its own 200K context. The team-lead delegates all implementation to workers, monitors progress, runs integration checks, and reports back. Review is handled by Stage 5 (not the team-lead), so both modes pass `--no-review`.

**Default mode (no `--swarm` flag):**
Read and invoke `.claude/commands/orchestrate.md` with the plan file and `--no-review` flag. The team-lead agent groups tasks into dependency-ordered waves and dispatches parallel workers with worktree isolation.

```
/orchestrate [plan file path] --no-review
```

**Swarm mode (`--swarm` flag):**
Read and invoke `.claude/commands/team.md` with the plan file and `--no-review` flag. The team-lead agent designs the team structure, spawns teammates, and coordinates execution autonomously (no user approval needed — plan is already verified by plan-checker).

```
/team [plan file path] --no-review
```

After the team-lead reports execution complete, proceed to Stage 5.

---

### Stage 5: Iterative Review

**Default mode:** Run iterative refinement sequentially.

**Swarm mode (`--swarm` flag) — parallel review + test:**

In swarm mode, dispatch review and browser testing as parallel background tasks since they only need the code to exist, not each other's results:

1. **Dispatch in parallel:**
   - Background Task 1: Run iterative-refinement skill (review→fix→review cycles)
   - Background Task 2: Run browser-testing skill (if UI changes detected in the diff)

2. **Wait for both to complete**

3. **Merge results:** If browser testing found issues not caught by review, create additional fix tasks and resolve them.

This parallelization is the key speedup of swarm mode — review and testing run simultaneously instead of sequentially.

**Both modes — iterative refinement parameters:**

Read and invoke the iterative-refinement skill in `.claude/skills/iterative-refinement/SKILL.md`.

Pass the configured parameters:
- `max_iterations`: from `--iterations` flag (default 3)
- `convergence`: from `--convergence` flag (default `fast`)
- `scope`: all changes on this branch vs main (`git diff main...HEAD`)

If iterative refinement exits with P1 > 0 (max iterations reached without convergence):
- STOP the pipeline
- Report: "Review found unresolved critical issues after [N] iterations. Run `/build` to address manually."
- Do NOT create a PR with known critical issues

---

### Stage 6: Compound (Knowledge Capture)

If the implementation involved solving a non-trivial problem:
- Run `/compound` to document it in `docs/solutions/`

Skip if the work was straightforward.

---

### Stage 7: Ship It

1. **Final commit** with conventional format:
   ```
   feat(<scope>): <description>
   ```

2. **Create PR** by reading and invoking `.claude/commands/pr.md`. The PR description should include:
   - Summary of the feature
   - Plan file reference
   - Review iterations completed and convergence status
   - Test results

3. **Report completion:**
   ```markdown
   ## /ship Complete

   ### Pipeline Summary
   | Stage | Status | Duration |
   |-------|--------|----------|
   | Requirements | Locked [N] decisions | — |
   | Plan | Written + verified ([N] checker passes) | — |
   | Deepen | Enriched by [N] research agents | — |
   | Execute | [wave/swarm] — [N] tasks completed | — |
   | Review | [N] iterations, converged at iteration [N] | — |
   | Compound | [captured/skipped] | — |
   | PR | Created: [PR URL] | — |

   ### Quality
   - Tests: [X passing]
   - Build: pass
   - Review: P1=0, P2=[N], P3=[N]
   - Iterations to convergence: [N]/[max]
   ```

4. **Clean up loop state:**
   - Remove `.claude/ship-loop.local.md` if it exists (Stop hook state)
   - Remove `.claude/ship-progress.local.md` if it exists (external loop progress)

5. Output the completion signal (detected by both the Stop hook and `scripts/ship.sh`):
   ```
   <promise>DONE</promise>
   ```

---

## Flags Reference

| Flag | Effect |
|------|--------|
| `--swarm` | Use `/team` with parallel execution + parallel review/test (SLFG pattern) |
| `--iterations N` | Set max review-improve iterations (default 3, max 10) |
| `--convergence fast` | Exit review loop when P1 = 0 (default) |
| `--convergence deep` | Exit review loop when P1 + P2 = 0 |
| `--convergence perfect` | Exit review loop when all findings = 0 |
| `--deploy` | After PR, also run deployment verification |
| `--external` | Set by `scripts/ship.sh` — skip Stop hook activation (external loop manages restarts) |

## Running Modes

### Interactive: `/ship` inside Claude

Type `/ship <feature>` in a Claude session. The Stop hook (`ship-loop.sh`) guards against premature exit — if Claude tries to stop before outputting `<promise>DONE</promise>`, the hook blocks exit and re-injects the prompt. This does NOT reset context — the conversation keeps growing. Best for features that fit within a single context window.

### External loop: `scripts/ship.sh`

Run from your terminal **before** entering Claude:

```bash
./scripts/ship.sh "add JWT authentication" --max 10 --swarm
```

This spawns a **fresh Claude process per iteration** (Ralph-style). Each iteration gets a clean 200K context window. State persists via git, plan files, and progress tracking. Best for large features that may exhaust context.

The external loop passes `--external` to `/ship`, which disables the Stop hook state file (avoiding conflict between inner and outer loop).

## Comparison: /build vs /ship vs ship.sh

| Aspect | `/build` | `/ship` (interactive) | `ship.sh` (external) |
|--------|----------|----------------------|----------------------|
| **Checkpoints** | Between every stage | None | None |
| **User input** | Required at each stage | Never | Never |
| **Context reset** | N/A | No (Stop hook, same session) | Yes (fresh process per iteration) |
| **Max outer iterations** | N/A | 5 (Stop hook) | 10 (configurable via `--max`) |
| **Review iterations** | 1 (default) | 3 (default) | 3 (default) |
| **PR creation** | Manual | Automatic | Automatic |
| **Best for** | Human-guided features | Single-context fire-and-forget | Large features, context exhaustion |

## When NOT to Use /ship

- **Unclear requirements** — if you can't describe the feature in one sentence, use `/build` with human checkpoints
- **Architectural decisions needed** — if the feature requires choosing between fundamentally different approaches, use `/discuss` + `/build`
- **First feature in a new codebase** — conventions aren't established yet; use `/build` to set patterns with human oversight
- **Database migrations** — always review migrations manually before applying; use `/build --deploy`

## Error Recovery

- If ANY stage fails fatally, STOP immediately and report what was completed and what failed
- **Clean up loop state** — remove `.claude/ship-loop.local.md` and `.claude/ship-progress.local.md` so neither loop mechanism restarts a broken pipeline
- Do NOT try to skip stages or work around failures
- Partial work (plan, branch, code) is preserved for the user to continue with `/build`
- If the execution stage fails, do NOT enter the review stage — there's nothing to review
