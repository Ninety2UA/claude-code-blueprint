---
name: autonomous-loop
description: Use when executing a multi-task plan autonomously — iterates through tasks with retry logic, completion tracking, and exponential backoff until the entire plan is done
---

# Autonomous Loop

## Overview

Execute a plan's tasks in an autonomous loop: pick a task, attempt it, verify it, mark it complete (or retry on failure), and move to the next one. Loop until all tasks are done. Inspired by the iterate-until-complete pattern where small, disciplined iterations compound into full plan completion.

**Core principle:** Loop until done. Retry on transient failures. Abort on fatal errors. Track progress via checkboxes.

## When to Use

- Executing a multi-step implementation plan autonomously
- Processing a PRD or task list end-to-end
- When the user says "just do it all" or "run through the whole plan"
- When you have 5+ sequential tasks to complete without needing human input between each one

**Don't use when:**
- Tasks require human decisions between steps (use executing-plans with checkpoints instead)
- Tasks are independent and can run in parallel (use resolve-in-parallel instead)
- You're exploring or unsure of the approach (use brainstorming/writing-plans first)

## The Iron Law

<HARD-GATE>
Run feedback loops INCREMENTALLY, not at project end. Verify after EACH task, not after all tasks. A chain of unverified changes is a chain of compounding bugs.
</HARD-GATE>

## Process

### Step 1: Load the Plan

Read the plan file and parse all tasks. Each task should have:
- A description of what to do
- A clear completion criteria (how to verify it's done)
- A checkbox status (`- [ ]` pending, `- [x]` complete)

If the plan doesn't have checkboxes, add them:
```markdown
- [ ] Task 1: Implement user model
- [ ] Task 2: Add validation middleware
- [ ] Task 3: Write integration tests
```

### Step 2: Classify Tasks

Before starting the loop, classify each task:

| Classification | Meaning | Example |
|---------------|---------|---------|
| **Independent** | Can be done in any order | Adding unrelated tests |
| **Sequential** | Must follow previous task | Migration before code that uses new schema |
| **Parallelizable** | Can run concurrently | Independent module implementations |

For parallelizable tasks, consider dispatching them via the resolve-in-parallel skill instead of looping sequentially.

### Step 3: Enter the Loop

```
┌─────────────────────────────────────────┐
│              AUTONOMOUS LOOP            │
│                                         │
│  ┌──► Pick next uncompleted task        │
│  │         │                            │
│  │    Attempt task                      │
│  │         │                            │
│  │    Verify (tests, build, evidence)   │
│  │         │                            │
│  │    ┌────┴────┐                       │
│  │    │ Pass?   │                       │
│  │    └────┬────┘                       │
│  │     yes │  no                        │
│  │         │   │                        │
│  │   Mark [x]  Classify error           │
│  │         │   │                        │
│  │         │   ┌────┴────┐              │
│  │         │   │ Fatal?  │              │
│  │         │   └────┬────┘              │
│  │         │  no    │  yes              │
│  │         │  Retry │  STOP & REPORT    │
│  │         │  (backoff)                 │
│  │         │                            │
│  │    More tasks?                       │
│  │     yes │  no                        │
│  └────────┘   │                         │
│          ALL DONE                       │
└─────────────────────────────────────────┘
```

For each iteration of the loop:

#### 3a. Pick Next Task

Select the next uncompleted task (`- [ ]`) in order. Skip tasks blocked by incomplete dependencies.

#### 3b. Attempt the Task

Execute the task following these sub-steps:
1. Read any files the task references
2. Write the implementation (follow TDD if writing code — test first)
3. Run the task's verification (tests, build, lint, or specific check)

#### 3c. Verify

Run verification immediately after the task:

```bash
# Always run after code changes
[test command]
[build command]
```

Check the specific acceptance criteria for the task too.

#### 3d. Handle Result

**On success:**
- Mark the task complete: `- [x] Task N: description`
- Update the plan file with the checkbox
- Log: "✓ Task N complete. [N/total] done."
- Continue to next task

**On failure — classify the error:**

| Error Type | Examples | Action |
|-----------|----------|--------|
| **Transient** | Rate limit, network timeout, flaky test | Retry with backoff |
| **Fixable** | Test failure from implementation bug | Debug and fix, then retry |
| **Fatal** | Missing dependency, wrong architecture, unclear requirement | STOP and report |

#### 3e. Retry Logic

When retrying a failed task:

```
Attempt 1: Immediate
Attempt 2: Wait 5 seconds, try different approach
Attempt 3: Wait 15 seconds, try with more context
Attempt 4 (max): STOP — escalate to user
```

**Max retries per task: 3** (4 total attempts including the initial one).

Between retries:
- Re-read the failing test output or error message
- Adjust the approach (don't just retry the same thing)
- If the second retry fails, try a fundamentally different approach on the third
- If all retries exhausted, mark the task as blocked and move to the next independent task

**Exponential backoff for transient errors:**
- Attempt 1: immediate
- Attempt 2: 5 second pause
- Attempt 3: 15 second pause
- Attempt 4: 45 second pause, then abort

### Step 4: Progress Tracking

After each task (pass or fail), report progress:

```markdown
## Loop Progress: [N/total] tasks complete

### Completed
- [x] Task 1: Implement user model ✓
- [x] Task 2: Add validation middleware ✓

### Current
- [ ] Task 3: Write integration tests (attempt 2/4 — fixing assertion)

### Remaining
- [ ] Task 4: Add error handling
- [ ] Task 5: Update API docs

### Blocked
- [ ] Task 6: Deploy (blocked by Task 3)
```

### Step 5: Loop Termination

The loop ends when one of these conditions is met:

| Condition | Action |
|-----------|--------|
| **All tasks complete** | Report success, run final verification |
| **Fatal error** | Stop, report what's done and what's blocked |
| **Max retries exhausted** on a blocking task | Stop, report the blocker |
| **User interrupts** | Stop, save progress, report current state |

### Step 6: Final Verification

When all tasks are complete, run a full verification pass:

```bash
# Full test suite
[test command]

# Full build
[build command]

# Lint
[lint command]
```

Report the final state:

```markdown
## Loop Complete: [total/total] tasks done

### Final Verification
- Tests: [X passing, Y failing]
- Build: [pass/fail]
- Lint: [pass/fail]

### Summary of Changes
- Files created: [count]
- Files modified: [count]
- Tests added: [count]
- Commits made: [list]
```

## Integration with Other Skills

| Situation | Skill to Use |
|-----------|-------------|
| Task requires writing code | Follow test-driven-development (red-green-refactor) |
| Task fails and needs debugging | Use systematic-debugging to find root cause |
| Multiple independent tasks ready | Dispatch via resolve-in-parallel |
| Task requires a plan change | Stop loop, use writing-plans to revise |
| All tasks done, ready to merge | Use finishing-a-development-branch |
| Loop complete, end of session | Use session-wrap to document |

## Quick Reference

| Parameter | Default | Override |
|-----------|---------|----------|
| Max retries per task | 3 | User can specify |
| Batch size before checkpoint | All (autonomous) | User can request checkpoints every N tasks |
| Backoff timing | 5s → 15s → 45s | Adjust for rate limits |
| Parallelizable tasks | Sequential | Dispatch via resolve-in-parallel |

## Common Mistakes

**Retrying the same approach** — If attempt 1 failed, attempt 2 must try something different. Einstein's definition of insanity applies to debugging too.

**Skipping verification between tasks** — "I'll verify at the end" means 5 tasks of compounding bugs. Verify after EVERY task.

**Not updating the plan** — If you complete a task but don't mark it `[x]`, the loop will try it again. Always update the checkbox.

**Continuing past fatal errors** — Transient errors get retried. Fatal errors (missing dependency, wrong architecture) require human input. Don't retry what can't succeed.

**Giant tasks in the loop** — Each task should be completable in minutes, not hours. If a task is too large, break it into subtasks before entering the loop.

**Not committing between tasks** — Commit after each successful task. If a later task breaks something, you can revert to the last good state without losing earlier work.
