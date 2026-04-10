---
name: resume-session
description: "Trigger this skill when the user says 'resume', 'continue', 'pick up where I left off', 'what was I working on', 'last session', 'keep going', 'where did we stop', 'let's continue', or anything suggesting they want to pick up prior work. Trigger at the start of any new session when CLAUDE.md Session Continuity has prior session data, even if the user just says 'hi', 'let's go', 'I'm back', or 'hey' — they likely want to resume. Trigger even when the user doesn't explicitly ask to resume, as long as there is session history to restore. Reads all session state (CLAUDE.md, STATE.md, STATUS.md, GOALS.md, BACKLOG.md, checkpoints) and presents an orientation with priorities and suggested starting point. DO NOT TRIGGER on a brand new project with no session history — use project-start instead. DO NOT TRIGGER when the user just wants a quick status overview without resuming work — use project-status instead."
---

# Resume Session

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
