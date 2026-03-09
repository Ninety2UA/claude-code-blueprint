---
description: "Full-cycle autonomous development. Chains discuss → plan → execute → review → verify into one pipeline."
---

# /build — Full-Cycle Development Pipeline

You are executing the full-cycle development pipeline. This chains together multiple skills into an autonomous workflow with review checkpoints between each stage.

**Announce at start:** "Starting the /build pipeline — full-cycle development from requirements to verified code."

## Pipeline Stages

Execute these stages IN ORDER. Do not skip stages. Stop between stages for user feedback.

### Stage 1: Discuss (Decision Capture)

Read and invoke `.claude/commands/discuss.md`. Capture user decisions BEFORE planning.

If the user has already provided clear, unambiguous requirements, summarize them as locked decisions and ask: "These are the locked decisions I'll plan around. Confirm or adjust?"

### Stage 2: Brainstorm (Design)

Read and invoke the brainstorming skill in `.claude/skills/brainstorming/SKILL.md`. Follow it exactly.

Explore 2-3 design alternatives. Present trade-offs. Get user approval before proceeding.

### Stage 3: Plan (Implementation Steps)

Before planning, dispatch the **learnings-researcher** agent to search `docs/` for relevant prior work. Incorporate findings into the plan.

Read and invoke the writing-plans skill in `.claude/skills/writing-plans/SKILL.md`. Convert the approved design into actionable steps.

After the plan is written, dispatch the **plan-checker** agent to verify the plan will work. Fix any BLOCKING issues before proceeding.

Get user approval of the plan.

### Stage 4: Execute (Implementation)

Read and invoke the executing-plans skill in `.claude/skills/executing-plans/SKILL.md`. Execute the plan in batches with checkpoints.

### Stage 5: Review (Quality Check)

Run `/review-swarm` to dispatch the full review agent swarm in parallel. This dispatches all configured review agents (code-reviewer, security-sentinel, performance-oracle, code-simplicity-reviewer, convention-enforcer, test-coverage-reviewer, plus conditional agents based on changes), then synthesizes findings via the findings-synthesizer.

Address all P1 (critical) and P2 (important) findings before proceeding. Use resolve-in-parallel to fix independent findings concurrently.

### Stage 6: Verify (Completion)

Read and invoke the verification-before-completion skill in `.claude/skills/verification-before-completion/SKILL.md`.

Run all tests. Verify all acceptance criteria from the plan are met. Confirm no regressions.

### Stage 6.5: Deploy Check (Optional)

If the user said `/build --deploy` or requests deployment:

Read and invoke the deployment-verification skill in `.claude/skills/deployment-verification/SKILL.md`. Dispatch the **deployment-verifier** agent to check all 8 verification areas.

Only proceed with deployment if the verdict is GO or CONDITIONAL GO. If NO-GO, stop and report the blocking issues.

### Stage 7: Compound (Knowledge Capture)

If the implementation involved solving a non-trivial problem (debugging, framework gotcha, architectural decision), run `/compound` to document it in `docs/solutions/`. This makes the solution searchable for future planning.

Skip this stage if the work was straightforward with no novel insights.

## Checkpoints

Between EVERY stage, report what was accomplished and ask: "Ready to proceed to [next stage]?"

The user can:
- **Approve** and continue to the next stage
- **Request changes** to the current stage's output
- **Skip** a stage (only if they explicitly say so)
- **Stop** the pipeline (work so far is preserved)

## Quick Mode

If the user says `/build --quick` or the change is small (< 3 files, clear requirements):
- Skip Stage 1 (Discuss) and Stage 2 (Brainstorm)
- Go directly to Plan → Execute → Review → Verify

## When Things Go Wrong

- If a stage fails, do NOT skip to the next stage
- Use the systematic-debugging skill if you encounter bugs during execution
- If blocked, stop and ask for help — don't guess
- If review finds critical issues, return to Stage 4 to fix them before Stage 6
