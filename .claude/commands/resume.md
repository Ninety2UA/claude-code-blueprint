---
description: "Resume work from where the last session left off. Loads context and orients you."
---

# Resume Previous Session

Reload all session context and present a clear starting point. Follow these steps in order:

## Step 1: Load Context (read all in parallel)

Read these files to understand where things stand:

- `CLAUDE.md` — Read the **Session Continuity** section first. This tells you what was done, what's remaining, and where to start.
- `docs/context/STATE.md` — Execution state: current wave, task progress, blockers (if exists)
- `docs/context/STATUS.md` — Current project state, in-flight work, known issues
- `docs/context/GOALS.md` — Current objectives and priorities
- `BACKLOG.md` — Pending items and their priority

Also check for checkpoint files:
```bash
ls docs/context/CHECKPOINT-*.md docs/context/STATE.md 2>/dev/null | sort -r | head -5
```

## Step 2: Check Git State

```bash
# Current branch
git branch --show-current

# Any uncommitted changes from last session
git status --short

# Recent commits
git log --oneline -10

# Any stashed work
git stash list
```

## Step 3: Present Orientation

Summarize for the user:

**Last session:** [date and brief summary from Session Continuity]

**Current state:**
- Branch: [branch name]
- Build: [status]
- Tests: [status]
- Uncommitted changes: [list or "clean"]

**Where to start:** [the "Start here" instruction from Session Continuity]

**Priority items:**
1. [Most important remaining task]
2. [Second priority]
3. [Third priority]

Ask: **"Ready to continue from here, or would you like to work on something else?"**
