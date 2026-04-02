---
description: "Full-cycle autonomous development. Chains discuss → plan → execute → review → verify into one pipeline."
---

# /build — Full-Cycle Development Pipeline

You are executing the full-cycle development pipeline. This chains together multiple skills into an autonomous workflow with review checkpoints between each stage.

**Announce at start:** "Starting the /build pipeline — full-cycle development from requirements to verified code."

## Pipeline Stages

Execute these stages IN ORDER. Do not skip stages. Stop between stages for user feedback.

### Stage 1: Discuss (Decision Capture)

Run the /discuss command. Capture user decisions BEFORE planning.

If the user has already provided clear, unambiguous requirements, summarize them as locked decisions and ask: "These are the locked decisions I'll plan around. Confirm or adjust?"

**Ambiguity Gate — score requirements before proceeding:**

| Dimension | Weight | Question |
|-----------|--------|----------|
| **Scope clarity** | 40% | Is it clear what's in and out of scope? Are boundaries explicit? |
| **Constraint clarity** | 30% | Are technical constraints, dependencies, and limitations stated? |
| **Success criteria clarity** | 30% | Are acceptance criteria specific and testable? |

Rate each dimension 0.0–1.0. Calculate: `clarity = (scope × 0.4) + (constraints × 0.3) + (criteria × 0.3)`

For **brownfield** tasks, add **Context clarity (15%)** and adjust weights to 35%/25%/25%/15%.

- If clarity **≥ 0.8** → proceed to Stage 2
- If clarity **< 0.8** → use AskUserQuestion to clarify the weakest dimension before proceeding

### Stage 2: Brainstorm (Design)

Invoke the brainstorming skill. Follow it exactly.

Explore 2-3 design alternatives. Present trade-offs. Get user approval before proceeding.

### Stage 3: Plan (Implementation Steps)

Before planning, dispatch the **learnings-researcher** agent to search `docs/` for relevant prior work. Incorporate findings into the plan.

Invoke the writing-plans skill. Convert the approved design into actionable steps.

After the plan is written, dispatch the **plan-checker** agent to verify the plan will work. Fix any BLOCKING issues before proceeding.

Get user approval of the plan.

### Stage 4: Execute (Implementation)

Choose the execution method based on plan complexity:

**Default (< 4 tasks or all sequential):**
Invoke the executing-plans skill. Execute the plan in batches with checkpoints.

**For complex plans (4+ tasks with mixed dependencies):**
Run `/orchestrate [plan file] --no-review`. This dispatches a team-lead agent that coordinates wave-based parallel execution. Review is handled by Stage 5, not the team-lead.

**For collaborative work (user says `/build --team`):**
Run `/team [plan file] --no-review`. This dispatches a team-lead agent that spawns teammates for collaborative implementation. Review is handled by Stage 5.

### Stage 5: Review (Quality Check)

Run `/review-swarm` to dispatch the full review agent swarm in parallel. This dispatches all configured review agents (code-reviewer, security-sentinel, performance-oracle, code-simplicity-reviewer, convention-enforcer, test-coverage-reviewer, plus conditional agents based on changes), then synthesizes findings via the findings-synthesizer.

Address all P1 (critical) and P2 (important) findings before proceeding. Use resolve-in-parallel to fix independent findings concurrently.

### Stage 6: Verify (Completion)

Invoke the verification-before-completion skill.

Run all tests. Verify all acceptance criteria from the plan are met. Confirm no regressions.

### Stage 7: Deploy Check (Optional)

If the user said `/build --deploy` or requests deployment:

Invoke the deployment-verification skill. Dispatch the **deployment-verifier** agent to check all 8 verification areas.

Only proceed with deployment if the verdict is GO or CONDITIONAL GO. If NO-GO, stop and report the blocking issues.

### Stage 8: Compound (Knowledge Capture)

If the implementation involved solving a non-trivial problem (debugging, framework gotcha, architectural decision), run `/compound` to document it in `docs/solutions/`. This makes the solution searchable for future planning.

Skip this stage if the work was straightforward with no novel insights.

## Checkpoints

Between EVERY stage, report what was accomplished and ask: "Ready to proceed to [next stage]?"

The user can:
- **Approve** and continue to the next stage
- **Request changes** to the current stage's output
- **Skip** a stage (only if they explicitly say so)
- **Stop** the pipeline (work so far is preserved)

## Iterate Mode

If the user says `/build --iterate N` (where N is 1-10):
- Replace the single-pass Stage 5 (Review) with the iterative-refinement skill
- Pass `max_iterations: N` and `convergence: fast` to the iterative-refinement skill
- The review→fix→review cycle runs up to N times until P1 findings reach zero
- All other stages remain the same with normal checkpoints

Example: `/build --iterate 5` runs the standard pipeline but reviews and fixes up to 5 times.

This can be combined with other flags: `/build --quick --iterate 3`

## Quick Mode

If the user says `/build --quick` or the change is small (< 3 files, clear requirements):
- Skip Stage 1 (Discuss) and Stage 2 (Brainstorm)
- Go directly to Plan → Execute → Review → Verify

## When Things Go Wrong

- If a stage fails, do NOT skip to the next stage
- Use the systematic-debugging skill if you encounter bugs during execution
- If blocked, stop and ask for help — don't guess
- If review finds critical issues, return to Stage 4 to fix them before Stage 6
