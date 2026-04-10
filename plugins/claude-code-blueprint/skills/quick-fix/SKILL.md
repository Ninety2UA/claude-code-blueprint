---
name: quick-fix
description: "Trigger this skill for ANY small, well-understood change, even if the user doesn't explicitly say 'quick'. Trigger scenarios: 'fix this bug', 'small change', 'typo', 'config change', 'rename', 'just fix it', 'quick fix', 'quick', 'update this value', 'change the default', 'swap this out', 'minor refactor', 'add a test for this', or any change touching fewer than 3 files where the approach is obvious and straightforward. Even if the user doesn't explicitly ask for a quick workflow, trigger this skill when the described change is clearly trivial — a single bug fix, a rename, a config tweak, a copy edit. Uses TDD: write failing test, fix, verify, commit. DO NOT TRIGGER when touching 4+ files, adding new public APIs or endpoints, changing data models, or when the approach is unclear — use brainstorming + build-pipeline instead."
argument-hint: "[describe the change]"
---

# Quick Fix — Lightweight Change Workflow

You are executing a small, well-understood change using the lightweight workflow.

## Step 1: Qualification Check

Before proceeding, verify this qualifies as a "quick" change:

**Qualifies:**
- Bug fix with obvious root cause (< 3 files touched)
- Typo, copy, or config fix
- Adding a test for existing behavior
- Renaming or minor refactor within a single module

**Does NOT qualify — redirect to brainstorming:**
- Touching 4+ files
- Adding new public API or endpoint
- Changing data models or schemas
- Anything where you're unsure of the approach

If the change does NOT qualify, say: "This looks like it needs the full workflow. Let me switch to brainstorming." Then invoke the brainstorming skill instead.

## Step 2: Write a Failing Test

Invoke the test-driven-development skill.

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
