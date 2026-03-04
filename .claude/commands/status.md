---
description: "Show current project status, goal alignment, blockers, and suggested next actions."
---

Read these files and present a concise status report:

1. Read **Session Continuity** section in `CLAUDE.md` — where the last session left off
2. Read `docs/context/STATUS.md` — in flight work, what's done, known issues, blockers
3. Read `docs/context/GOALS.md` — objectives, milestones, priorities
4. Read `BACKLOG.md` — check Inbox for unprocessed items, Triaged for P0/P1 items
5. Run:
   ```bash
   git log --oneline -10
   git status
   git branch --show-current
   ```

Then present:

**Project Status — [date]**

**Code State:**
- Build/Tests/Lint status from STATUS.md
- Current branch and uncommitted changes from git

**In Flight:**
- [table of active work from STATUS.md with blockers highlighted]

**Goal Progress:**
- [which objectives/milestones are advancing, which are stalled]

**Attention Needed:**
- [P0/P1 backlog items not yet in flight]
- [Blocked items and what unblocks them]
- [Known issues by severity]
- [Unprocessed inbox items count]

**Suggested Next Actions (top 3):**
1. [highest priority action based on goals + status + blockers]
2. [second priority]
3. [third priority]

Include reasoning for each suggestion — why this over other options.
