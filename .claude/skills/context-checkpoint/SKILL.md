---
name: context-checkpoint
description: Use when you need to capture mid-session state without doing a full /wrap, or when context window is getting large and you want a recovery point
---

# Context Checkpoint

## Overview

Capture the current session state into a lightweight checkpoint file. This is a faster, less comprehensive alternative to `/wrap` — use it when you need a save point but aren't ending the session.

## When to Use

- Mid-session when you've made significant progress and want a recovery point
- Before a risky operation (large refactor, dependency upgrade)
- When the context window is getting large and you want to preserve key decisions
- When switching focus within the same session (checkpoint current work, start new task)

<HARD-GATE>
This is a documentation-only operation. Do NOT modify source code, tests, or configuration files. If you discover code changes needed, note them in the checkpoint.
</HARD-GATE>

## Process

### Step 1: Gather State

Quickly collect:
```bash
# Current branch and recent commits
git branch --show-current
git log --oneline -5

# Uncommitted changes
git status --short

# Current test/build state (if known)
```

### Step 2: Write Checkpoint

If Session Continuity in CLAUDE.md already has content, update it in place. Otherwise, create a checkpoint file.

**Option A: Update Session Continuity** (preferred if session is near-end)

Update the Session Continuity section in CLAUDE.md with current state.

**Option B: Create checkpoint file** (preferred for mid-session save points)

Create `docs/context/CHECKPOINT-[YYYY-MM-DD-HHMM].md`:

```markdown
# Checkpoint: [brief description]

**Timestamp:** YYYY-MM-DD HH:MM
**Branch:** [current branch]

## What's been done so far
- [accomplishment 1 with file paths]
- [accomplishment 2]

## Current state
- Build: [passing/failing]
- Tests: [X passing, Y failing]
- Uncommitted changes: [list or "none"]

## Key decisions made
- [decision 1 and rationale]

## Next steps (in order)
1. [immediate next task]
2. [following task]

## Open questions
- [anything unresolved]
```

### Step 3: Confirm

Tell the user: "Checkpoint saved. You can resume from this point if context is lost."

## Quick Reference

| Situation | Action |
|-----------|--------|
| Mid-session save | Create checkpoint file |
| Before risky operation | Create checkpoint file |
| Nearly done for the day | Update Session Continuity instead |
| Switching focus | Create checkpoint, note the switch |

## Common Mistakes

**Over-documenting** — A checkpoint should take 30 seconds to write. If you're spending more than a minute, you're writing a `/wrap`.

**Modifying code** — This is documentation only. The checkpoint captures state, it doesn't change it.

**Forgetting uncommitted changes** — Always run `git status` and include the results. The most common context loss is forgetting what was changed but not committed.
