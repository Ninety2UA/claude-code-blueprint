---
name: session-wrap
description: "Use at the end of a work session to summarize accomplishments, record learnings, and update all project documentation to reflect current state. Ensures continuity between sessions."
---

# Session Wrap-Up

Summarize what was accomplished, record what was learned, and update every project document that was affected. The goal: the next session — whether it's you, a different agent, or a human — can pick up exactly where this one left off by reading the Session Continuity section in CLAUDE.md.

<HARD-GATE>
Do NOT modify source code, tests, or infrastructure files. This is a documentation-only operation. If you discover something that needs a code change, add it to BACKLOG.md instead.
</HARD-GATE>

## Step 1: Gather Context

Read ALL of these before writing anything. Do as many in parallel as possible.

**Project state files (read all):**
- `CLAUDE.md` — Session Continuity section, Key Learnings, behavioral rules
- `docs/context/STATUS.md` — in flight, up next, what's done, known issues
- `docs/context/GOALS.md` — current objectives, milestones, non-goals
- `docs/context/CONVENTIONS.md` — tech stack, patterns, boundaries (check if new patterns emerged)
- `BACKLOG.md` — inbox, triaged, parked items

**Documentation files (check which exist):**
- `docs/plans/*.md` — any active implementation plans
- `docs/decisions/*.md` — any architecture decision records
- `docs/specs/*.md` — any feature specs
- `docs/research/*.md` — any research docs

**Git state (run all in parallel):**
```bash
# Recent commits (broader session view)
git log --oneline -20

# Uncommitted changes
git status

# File-level diff summary
git diff --stat

# Session-window commits (approximate)
git log --format="%h %s (%ai)" --since="8 hours ago"

# Broader diff against session start
git diff --stat HEAD~10 HEAD 2>/dev/null

# New files added this session
git log --diff-filter=A --name-only --since="8 hours ago" --format=""

# Files deleted this session
git log --diff-filter=D --name-only --since="8 hours ago" --format=""

# Current branch
git branch --show-current

# Test status (if test command is known from CONVENTIONS.md)
# [test command] 2>&1 | tail -5

# Build status (if build command is known)
# [build command] 2>&1 | tail -5
```

**Auto-memory (if it exists):**
```bash
find ~/.claude -name "MEMORY.md" -path "*$(basename $(pwd))*" 2>/dev/null
```

## Step 2: Analyze Session Work

Before writing anything, build a complete mental model:

1. **What changed?** — Map every git commit and uncommitted change. Include files added, modified, deleted, renamed. Note new dependencies added.
2. **What decisions were made?** — Architectural choices, technology selections, pattern adoptions, approaches rejected. Look beyond commits — file structure changes, new directories, config changes all signal decisions.
3. **What was learned?** — Pitfalls discovered, debugging dead ends, things that worked unexpectedly well or poorly, workarounds needed, documentation that was misleading.
4. **What broke or was surprising?** — Edge cases found, assumptions that were wrong, regressions introduced and fixed, unexpected behaviors.
5. **What's unfinished?** — Work started but not completed, tests that need writing, refactors deferred, TODO comments added.
6. **What's the state of the code right now?** — Does it build? Do tests pass? How many tests pass/fail? Are there uncommitted changes? Is the working tree clean?
7. **Goal alignment** — Cross-reference completed work against GOALS.md objectives and milestones. Did this session advance current goals? Did scope creep happen? Should any goals be updated?

## Step 3: Present Summary to User

Present a structured summary. Be specific — include file paths, commit hashes, numbers.

**Session Summary**
- Duration estimate (from first to last git timestamp, or note if unclear)
- One-sentence overview of what was accomplished

**Changes Made**
- Features added or modified (with file paths and commit hashes)
- Bugs fixed (with root cause)
- Tests added or modified (with pass/fail counts)
- Infrastructure or configuration changes
- Dependencies added or removed
- Documentation changes

**Decisions Made**
- What was decided and why (brief — detail goes in ADRs)
- Trade-offs that were accepted
- Approaches considered and rejected (and why)

**Learnings**
- Pitfalls discovered (things that will waste time again if not recorded)
- Patterns that worked well (worth replicating in other parts of the project)
- Assumptions that were wrong (correct the mental model)
- Debugging insights (what was tried, what worked, what was the root cause)

**Current State**
- Build status: passes / fails / not configured
- Test status: X passing, Y failing, Z skipped
- Lint status: clean / N warnings / N errors
- Uncommitted changes: [list or "working tree clean"]
- Current branch: [branch name]

**Remaining Work**
- Immediate next steps (what the next session should start with, in order)
- Items for backlog (bugs found, ideas sparked, follow-ups)
- Open questions that need human input
- Blocked items and what unblocks them

**Goal Alignment**
- Which goals/milestones this session advanced
- Whether any work was off-goal
- Whether goals or milestones need updating

Ask the user: **"Does this look accurate? Anything to add or correct before I update the docs?"**

**Wait for confirmation before proceeding.** The user may have context not in the git history — verbal decisions, Slack conversations, things they want emphasized or omitted.

## Step 4: Update CLAUDE.md — Session Continuity

Update the **Session Continuity** section at the top of CLAUDE.md. This is what the next session reads first.

```markdown
## Session Continuity

**Last session:** YYYY-MM-DD

**What was done:**
- [Specific accomplishment 1 with file paths]
- [Specific accomplishment 2]
- [etc.]

**What's remaining:**
- [Next task 1 — enough detail to start immediately]
- [Next task 2]
- [etc.]

**Start here:** [Exact instruction for next session, e.g., "Continue implementing the auth middleware — tests in tests/auth.test.ts are passing, next step is refresh token rotation in src/auth/refresh.ts"]

**Current state of the code:**
- Build: [passes / fails / error message]
- Tests: [X passing, Y failing — list failing tests if any]
- Uncommitted changes: [none / list of files]
```

**Rules:**
- Be specific enough that a new agent can start immediately without re-reading everything
- Include file paths and test names
- If there are failing tests, list them by name
- "Start here" should be a single actionable instruction, not a list

## Step 5: Update CLAUDE.md — Key Learnings

Append new entries to the **Key Learnings** section at the bottom of CLAUDE.md:

```markdown
### YYYY-MM-DD: [Brief title of learning]
[What was learned and why it matters. Include specific details — file paths, error messages, version numbers — that will help future sessions avoid the same pitfall or replicate the same success. Link to ADRs if relevant.]
```

**Rules:**
- Only add learnings that will matter in future sessions — not every commit needs an entry
- Keep each entry to 2-4 sentences but be specific (include file paths, commands, error messages)
- If a learning invalidates a previous entry, update the previous entry rather than adding a contradictory new one
- If conventions or patterns were established, ALSO update docs/context/CONVENTIONS.md (Step 7)

## Step 6: Update docs/context/STATUS.md

Edit STATUS.md to reflect the current state. Map to the table format:

**Current State of the Code:**
- Update build/test/lint status with actual current values
- Update "last verified" date

**In Flight:**
- Update the table: progress, blockers, notes
- Remove rows for items completed this session
- Add rows for items started but not finished
- Mark blocked items with what unblocks them

**Up Next:**
- Reorder based on what the session revealed
- Add new items discovered during the session
- Remove items that are no longer relevant
- Cross-reference GOALS.md to ensure alignment

**What's Done:**
- Add rows to the commit log table for significant work done this session
- Use actual commit hashes and dates from git log
- Keep the last 20 entries; trim the oldest if longer
- Group related commits into single entries when they represent one logical change

**Decisions Made:**
- Add rows for decisions made this session
- Link to ADR files if created (Step 10)
- Keep last 10 entries

**Known Issues:**
- Add new bugs or technical debt discovered
- Remove issues that were fixed this session
- Update severity, workarounds, or discovery dates

**Dependencies and External Blockers:**
- Add any new external dependencies or blockers
- Update status of existing ones
- Remove resolved ones

**Update the "Last updated" date at the top.**

## Step 7: Update docs/context/CONVENTIONS.md (if needed)

Only update if this session:
- Established new patterns (e.g., "we now use React Query for all data fetching")
- Changed the tech stack (added a library, switched a tool)
- Discovered that an existing convention doesn't work and needs changing
- Added new commands to the project (update the Commands section)
- Established new boundaries (files that shouldn't be modified)

If no conventions changed, skip this file.

## Step 8: Update docs/context/GOALS.md (if needed)

Only update if:
- A goal was completed or substantially advanced — update Status
- A milestone was reached — update the milestones table
- Scope changed and non-goals need updating
- A new goal emerged from the session's work
- Priority framework needs adjustment

If no goals were affected, skip this file.

## Step 9: Update BACKLOG.md

**Inbox:**
- Remove items that were completed this session
- Add new items discovered during the session (bugs found, ideas sparked, follow-ups)

**Triaged:**
- Move items from Inbox to Triaged if they were discussed and prioritized
- Add priority and type tags: `P2 [feature] description`
- Update existing triaged items if scope or priority changed

**Parked:**
- Move items to Parked if explicitly set aside, with reason
- If an item was partially addressed, update it rather than removing

## Step 10: Update Active Plans (if applicable)

Check `docs/plans/` for any active implementation plan being followed:

- Mark completed tasks/steps with checkboxes or strikethrough
- Note deviations from the plan and why they were necessary
- Update remaining task estimates if complexity changed
- If the plan is fully complete, add a completion note at the top:
  ```markdown
  > **Status: COMPLETE** — All tasks implemented as of YYYY-MM-DD.
  ```
- If the plan needs revision, note what needs to change and whether to update now or defer

If no plan was being followed, skip this step.

## Step 11: Update Active Specs (if applicable)

Check `docs/specs/` for any spec that was being implemented:

- Update acceptance criteria checkboxes
- Note any scope changes or requirement discoveries
- Add open questions that emerged during implementation

If no spec was being followed, skip this step.

## Step 12: Create ADRs (if applicable)

If significant architectural decisions were made this session, create new ADR files:

- File: `docs/decisions/NNN-kebab-case-title.md`
- Use the template from `docs/decisions/README.md`
- Number sequentially (check existing ADRs for the next number)
- Focus on the *why* — the code shows *what*, the ADR captures the reasoning
- Link the ADR from STATUS.md Decisions Made table

Only create ADRs for decisions that would be non-obvious to someone reading the code 6 months later. Don't create ADRs for routine choices.

## Step 13: Update Auto-Memory (if it exists)

Check for Claude Code project memory:
```bash
find ~/.claude -name "MEMORY.md" -path "*$(basename $(pwd))*" 2>/dev/null
```

If it exists, update with:
- New pitfalls or gotchas (things that wasted time and will waste time again)
- Updated patterns (conventions established or changed)
- Recent changes summary (1-2 lines of what was done)
- Updated "start here" context
- Keep the memory file under 200 lines — condense older entries if growing

If no memory file exists, skip this step.

## Step 14: Clean Up Temporary Artifacts

Check for and clean up session artifacts:

```bash
# List any git worktrees created during the session
git worktree list

# Check for orphaned worktrees (worktree directory deleted but ref remains)
git worktree prune --dry-run

# Check for temp files in project root
ls -la *.tmp *.bak *~ 2>/dev/null
```

**Actions:**
- If feature worktrees exist and the branch was merged, remove them: `git worktree remove <path>`
- If worktrees are still in progress, document them in Session Continuity ("worktree at .claude/worktrees/feat-auth still active")
- Remove any temp/backup files that shouldn't be committed
- If completed plans should be archived, add a completion note at the top rather than moving/deleting them

## Step 15: Commit Documentation Updates

After all documentation updates are complete:

```bash
git add CLAUDE.md BACKLOG.md docs/
git commit -m "docs: session wrap-up YYYY-MM-DD — [one-line summary of session work]"
```

If ADRs were created, mention them in the commit message:
```bash
git commit -m "docs: session wrap-up YYYY-MM-DD — [summary]. ADR-NNN: [decision title]"
```

## Step 16: Final Verification

After committing:

```bash
# Verify no source code was accidentally modified
git diff --name-only | grep -v -E '\.(md|json)$' | head -5

# Verify working tree is clean (or only has expected uncommitted work)
git status
```

If any non-documentation files were modified, revert them:
```bash
git checkout -- [file]
```

Present final confirmation to the user:
- List which files were updated (with brief reason for each)
- List which files were skipped (and why — "no changes in that domain")
- Flag any items that need human attention
- Confirm the docs commit was made

## Constraints

- Do NOT modify source code, tests, configs, or infrastructure — documentation only
- Do NOT create new documentation files unless creating an ADR (Step 12)
- Keep all updates factual and concise — no filler
- Preserve existing formatting and structure of each file
- If nothing changed in a file's domain, skip it — don't update for the sake of updating
- Never fabricate or assume what was done — use git history as ground truth
- If something is ambiguous, ask the user rather than guessing
- Always get user confirmation (Step 3) before modifying any files

## Success Criteria

- [ ] User received clear, accurate summary of session work with file paths and commit hashes
- [ ] User confirmed summary before docs were updated
- [ ] CLAUDE.md Session Continuity section has specific "start here" instruction
- [ ] CLAUDE.md Key Learnings has new entries (if learnings exist)
- [ ] docs/context/STATUS.md reflects actual current state with updated tables
- [ ] docs/context/STATUS.md commit log has new entries with real commit hashes
- [ ] docs/context/GOALS.md updated only if goals/milestones were affected
- [ ] docs/context/CONVENTIONS.md updated only if patterns/stack changed
- [ ] BACKLOG.md has completed items removed and new items added
- [ ] Active plans in docs/plans/ reflect current progress
- [ ] Active specs in docs/specs/ have updated acceptance criteria
- [ ] ADRs created for significant decisions
- [ ] Auto-memory updated if it exists
- [ ] All doc updates committed with descriptive message
- [ ] No source code files were modified
- [ ] "Last updated" dates are current
