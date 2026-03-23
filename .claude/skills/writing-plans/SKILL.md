---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## Shadow Path Tracing

For every new data flow in the plan, trace four paths — not just the happy path:

```
INPUT ──► VALIDATION ──► TRANSFORM ──► PERSIST ──► OUTPUT
  │            │              │            │           │
  ▼            ▼              ▼            ▼           ▼
[nil?]    [invalid?]    [exception?]  [conflict?]  [stale?]
[empty?]  [too long?]   [timeout?]    [dup key?]   [partial?]
```

For each node: document what happens on each shadow path in the task description. If a shadow path is unhandled, add a task to handle it.

## Error/Rescue Map

For tasks that introduce new service calls, external APIs, or database operations, include an error map in the task description:

```
METHOD/CODEPATH       | WHAT CAN GO WRONG    | HANDLED? | USER SEES
Service#call          | API timeout          | ?        | ?
                      | Malformed response   | ?        | ?
                      | Rate limited (429)   | ?        | ?
```

Any "?" in the HANDLED column becomes a sub-task. Every external call must have its failure mode explicitly addressed in the plan.

## Interface Context for Parallel Executors

When creating plans that will run in parallel (wave execution via `/orchestrate`), embed key types/interfaces/exports from the codebase directly in the plan. This prevents executors from wasting context exploring the codebase to discover contracts.

**When a plan USES existing code:**

After determining which files the task touches, extract the key interfaces from source files it depends on:

```markdown
### Interface Context
<!-- Extracted from codebase — executor should use directly, no exploration needed -->

From `src/types/user.ts`:
```typescript
export interface User {
  id: string;
  email: string;
  role: 'admin' | 'member';
}
```

From `src/api/auth.ts`:
```typescript
export function validateToken(token: string): Promise<User | null>;
```
```

**When a plan CREATES new interfaces consumed by later tasks:**

Add a "Task 0: Define contracts" step that creates type files before implementation:

```markdown
### Task 0: Define interface contracts

**Files:**
- Create: `src/types/newFeature.ts`

**Step 1:** Create type definitions that downstream tasks will implement against.
These are the contracts — implementation comes in later tasks.

**Step 2:** Commit: `chore: define newFeature type contracts`
```

**When to include:** Plan touches files that import from other modules, creates a new API endpoint, modifies a component's props, or depends on a previous wave's output.

**When to skip:** Plan is self-contained (creates everything from scratch), pure configuration, or all patterns are already established.

## Verification Commands

Every task step that produces a testable result should include a **runnable verification command** — not just "verify it works."

| Bad | Good |
|-----|------|
| "Verify it works" | `Run: pytest tests/auth.py -v` → Expected: PASS |
| "Check the endpoint" | `Run: curl -s localhost:3000/api/health \| jq .status` → Expected: `"ok"` |
| "Make sure it builds" | `Run: npm run build` → Expected: exit 0, no errors |

If no automated verification exists yet, say so explicitly: `No automated verification available — requires manual browser check at /dashboard`. This honesty prevents executors from inventing fake checks.

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses executing-plans
