---
description: "Fast-track a small, well-understood change with TDD and verification gates."
argument-hint: "[describe the change]"
---

# /quick — Lightweight Change Workflow

You are executing a small, well-understood change using the lightweight workflow.

## Step 1: Qualification Check

Before proceeding, verify this qualifies as a "quick" change:

**Qualifies:**
- Bug fix with obvious root cause (< 3 files touched)
- Typo, copy, or config fix
- Adding a test for existing behavior
- Renaming or minor refactor within a single module

**Does NOT qualify — redirect to /plan:**
- Touching 4+ files
- Adding new public API or endpoint
- Changing data models or schemas
- Anything where you're unsure of the approach

If the change does NOT qualify, say: "This looks like it needs the full workflow. Let me switch to /plan." Then read and invoke `.claude/commands/plan.md` instead.

## Step 2: Write a Failing Test

Read the test-driven-development skill in `.claude/skills/test-driven-development/SKILL.md`.

Write a test that describes the expected behavior BEFORE writing any implementation code. Run it — it should fail (RED).

## Step 3: Implement the Fix

Write the minimum code to make the test pass. Run the test — it should pass (GREEN).

## Step 4: Verify

```bash
# Run the full test suite — not just your test
[test command]

# Run the build
[build command]

# Check for lint issues
[lint command]
```

All must pass before committing.

## Step 5: Commit

```bash
git add [specific files]
git commit -m "[type](scope): [description]"
```

Follow the commit conventions in CLAUDE.md.

The user's change description: $ARGUMENTS
