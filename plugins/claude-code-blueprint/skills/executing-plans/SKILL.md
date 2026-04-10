---
name: executing-plans
description: "Trigger this skill when executing a written plan sequentially with human review checkpoints between batches. Trigger scenarios: 'execute the plan', 'implement the plan', 'work through the tasks', 'follow this plan', 'run through the plan step by step', 'execute sequentially', or when the user has a plan file and wants controlled, checkpoint-based execution with human review between batches. Even if the user doesn't explicitly mention checkpoints, trigger this skill when they want sequential plan execution with oversight rather than autonomous or parallel approaches. DO NOT TRIGGER when tasks can run in parallel and speed matters — use orchestrate instead. DO NOT TRIGGER when spawning collaborative teammates with shared task lists — use team-execution instead. DO NOT TRIGGER for fully autonomous execution without human checkpoints — use autonomous-loop instead."
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for architect review.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Batch
**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Report
When batch complete:
- Show what was implemented
- Show verification output
- Say: "Ready for feedback."

### Step 4: Continue
Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 5: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## Deviation Scope Boundary

When executing, you will discover issues not in the plan. Apply these rules:

**Auto-fix (no permission needed):**
- Bugs directly caused by the current task's changes (wrong logic, type errors, broken imports)
- Missing critical functionality for correctness/security (null checks, input validation, error handling)
- Blocking issues preventing task completion (missing dependency, wrong path)

**Scope boundary:** Only fix issues DIRECTLY caused by the current task's changes. Pre-existing warnings, linting errors in unrelated files, or tech debt you notice → add to BACKLOG.md, don't fix inline.

**Fix attempt limit:** After 3 auto-fix attempts on a single issue within a task, STOP trying. Document it under `### Deferred Issues` in the batch report and move to the next task. Don't burn context retrying what isn't working.

**Must ask the user FIRST:**
- New database tables or major schema changes
- Switching frameworks or libraries
- Changing public API contracts
- Modifying auth logic
- Adding new environment variables

## Stub Tracking

After completing each batch, scan created/modified files for stub patterns before reporting:

- Hardcoded empty values flowing to rendering: `= []`, `= {}`, `= null`, `= ""`
- Placeholder text: "not available", "coming soon", "placeholder", "TODO", "FIXME"
- Components with no data source wired (props always receiving empty/mock data)

If stubs are found, include a `### Known Stubs` section in the batch report:

```markdown
### Known Stubs
- `src/components/Dashboard.tsx:45` — `items = []` hardcoded, API not wired yet (Task 5 will resolve)
- `src/api/users.ts:23` — `// TODO: add pagination` (out of scope for this plan, added to BACKLOG)
```

Don't mark a batch as fully complete if stubs prevent the planned feature from working end-to-end. Either wire the data or document which future task resolves it.

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly
- 3 auto-fix attempts on the same issue haven't resolved it (see Deviation Scope Boundary)

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Analysis Paralysis Guard

**If you make 5+ consecutive read-only operations (Read, Glob, Grep) without any Edit, Write, or Bash action that modifies state, STOP.**

You are in analysis paralysis. Do one of:
1. **Write code** — you have enough information, start implementing
2. **Report a blocker** — explain what's preventing you from writing code
3. **Ask for help** — if the plan is unclear, ask rather than endlessly reading

Reading code is preparation. Writing code is progress. Don't confuse the two.

## Assumption Tracking

During execution, you will make interpretive decisions — the spec says "handle errors" and you choose to return 400 with a JSON body; the plan says "add validation" and you choose specific validation rules. These decisions are invisible unless documented.

**After each task**, if you made any interpretive choices, append them to the plan file under an `### Assumptions` heading:

```markdown
### Assumptions
- Task 3: "Handle errors" interpreted as returning 400 with `{ error: string }` JSON body (not HTML error pages)
- Task 3: Rate limiting set to 100 req/min per IP (common default, not specified in plan)
- Task 5: "Support pagination" interpreted as cursor-based, not offset-based (better for large datasets)
```

**Rules:**
- Only document decisions where a reasonable engineer might have chosen differently
- Skip obvious choices (naming a variable, import ordering)
- The user reviews these at batch checkpoints (Step 3), not in real-time — don't interrupt execution to ask about each one
- If an assumption has cascading impact (other tasks will build on it), flag it: `[cascading]`

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Between batches: just report and wait
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent
- Document interpretive decisions in Assumptions section (see above)

## Integration

**Required workflow skills:**
- **using-git-worktrees** - REQUIRED: Set up isolated workspace before starting
- **writing-plans** - Creates the plan this skill executes
- **finishing-a-development-branch** - Complete development after all tasks
