---
name: writing-plans
description: "Trigger this skill when converting an approved design or spec into a detailed implementation plan with exact file paths, code snippets, dependency ordering, and test strategies. Trigger when the user says 'write a plan', 'create a plan', 'implementation steps', 'break this down into tasks', 'how do we implement this', 'plan out the work', or 'turn this design into tasks'. Trigger after brainstorming produces an approved design — even if the user doesn't explicitly ask for a plan, suggest this skill once a design is approved. Also trigger when the user has a clear spec from any source and needs it decomposed into bite-sized executable steps. DO NOT TRIGGER when the user hasn't brainstormed or designed yet — use brainstorming first to produce an approved design. DO NOT TRIGGER for executing an existing plan — use executing-plans instead. DO NOT TRIGGER for enriching a plan with research — use deepen-plan instead."
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

## When NOT to Use

- **No design exists yet** — run `/brainstorming` first to lock the design; planning a vague idea produces a vague plan.
- **The change qualifies as a quick fix** (< 3 files, obvious root cause) — use `/quick-fix` and skip the plan document.
- **You're triaging open work** — use `/backlog-triage`; `/writing-plans` produces *one* plan for *one* change.
- **You're researching feasibility** — use `/spike-exploration` or `/deep-research`; the plan is the artifact *after* feasibility is settled.
- **You're fixing a regression** — use `/systematic-debugging`; debug-first then plan if the fix is non-trivial.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Requirements Quality Check (Rigor Probes)

Before diving into planning, verify the incoming requirements are solid. If requirements came from brainstorming, scan for these five gap types. Fire each as a prose question to the user — not a checklist.

| Probe | Question | When to Fire |
|-------|----------|-------------|
| **Evidence gap** | "What evidence do we have that this is actually the problem?" | Requirements assert a problem without citing user data, logs, or incidents |
| **Specificity gap** | "Can you give a concrete example of when this would happen?" | Requirements describe abstract scenarios without grounding in real use cases |
| **Counterfactual gap** | "What if we didn't do this — what breaks?" | Requirements lack a clear cost-of-inaction; the feature might be nice-to-have |
| **Attachment gap** | "Are we attached to this solution, or is there a simpler approach?" | Requirements prescribe a specific implementation rather than describing the problem |
| **Durability gap** | "Will this still matter in 6 months?" | Requirements address a transient pain point that may resolve itself |

**Rules:**
- Fire at most 2-3 probes per planning session — don't interrogate
- Skip probes where the answer is obvious from the requirements doc
- If requirements came from a rigorous brainstorming session with probes already applied, skip this section entirely
- Probes that surface real gaps → pause planning, send the user back to refine requirements
- Probes that are satisfactorily answered → proceed to planning

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

## Boundaries

Every plan should declare three lists, in this order:

- **Always do** — non-negotiables for this work (run tests before commits, follow existing naming, validate user input at boundaries, cite framework docs for non-obvious patterns)
- **Ask first** — actions that need explicit user approval (DB schema changes, new dependencies, auth changes, env var additions, public API changes, anything in CLAUDE.md's "Must ask the user FIRST" list)
- **Never do** — hard prohibitions (commit secrets, edit vendor directories, remove failing tests without approval, skip verification, use `--no-verify` to bypass hooks)

The three-tier framing is sharper than a generic "be careful" — at decision time, an action falls into exactly one bucket. Plans without explicit boundaries inherit them from CLAUDE.md, but for non-trivial work always restate the work-specific items.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The plan is obvious, I'll just describe the steps" | Vague plans become vague code. Exact file paths, exact commands, and inline code prevent the executor from improvising. |
| "I'll skip verification commands and figure them out at run-time" | The executor will skip verification too. If the plan-author can't articulate "Expected: PASS," neither will the implementer. |
| "Interface contracts are implementation details" | When parallel executors share a contract, the contract IS the spec. Skipping the interface section creates Wave-N integration breakage. |
| "Plans are overhead — let me start coding" | Planning IS the task. Implementation without a plan is typing, not engineering. The cost of the plan is paid back many times over in fewer wrong turns. |
| "I'll write the plan after the design — they're the same thing" | Brainstorming produces a *what*; the plan produces a *how with file paths and commands*. Conflating them loses the executable detail. |
| "Boundaries are for big projects" | Boundaries are cheapest to declare on small plans (3 lines per list) and most expensive to recover from when missing. |

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/plans/<filename>.md`. What's next?**

**1. Deepen the plan (`/deepen`)** — Dispatch parallel research agents to enrich each section with best practices, prior solutions, and framework docs before executing

**2. Subagent-Driven (this session)** — I dispatch a fresh subagent per task, review between tasks, fast iteration. Good for hands-on oversight.

**3. Parallel Orchestration (`/orchestrate`)** — Executes the wave plan: independent tasks run in parallel within each wave. Faster total time for plans with concurrent tasks.

**4. Agent Teams (`/team`)** — Collaborative teammates with file ownership and shared task list. Best for 4+ tasks touching different areas. Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`.

**Which approach?"**

**If Deepen chosen:**
- Invoke `/deepen` with the plan file path
- After deepening, re-present execution options (2-4)

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Orchestration chosen:**
- Invoke `/orchestrate` with the plan file path
- Team-lead agent handles wave grouping and parallel dispatch

**If Agent Teams chosen:**
- Invoke `/team` with the plan file path
- Team-lead agent designs team structure and assigns file ownership
