# Implementation Plans

Store implementation plans as: `YYYY-MM-DD-feature-name.md`

Plans are created by the `writing-plans` skill after a brainstorming session produces an approved design. They should be detailed enough for an engineer (or agent) with zero project context to follow — exact file paths, exact code, exact test commands.

## Lifecycle

1. **Created** by `/plan` → brainstorming skill → writing-plans skill
2. **Executed** by executing-plans skill or subagent-driven-development skill
3. **Updated** during execution as tasks are completed or deviations occur
4. **Completed** when all tasks are done — add completion note at top
5. **Archived** — completed plans stay in this directory as history

## Plan Document Structure

Every plan MUST include:

```markdown
# [Feature Name] Implementation Plan

> **Status:** [IN PROGRESS / COMPLETE as of YYYY-MM-DD / ABANDONED — reason]

**Goal:** [One sentence describing what this builds]
**Architecture:** [2-3 sentences about the approach]
**Tech Stack:** [Key technologies/libraries]
**Estimated tasks:** [N tasks, ~X hours]

---

### Task 1: [Component Name]
**Files:** Create/Modify/Test paths
**Steps:** Bite-sized steps with exact code and test commands

### Task 2: ...
```

## Rules

- Exact file paths for every file touched
- Complete code in the plan (not "add validation" — show the actual code)
- Exact test commands with expected output
- Tasks ordered by dependency
- Each task independently verifiable with a clean commit
- Plans are prompts, not documents that become prompts — write them as if the executor has zero context

## Updating During Execution

- Check off completed tasks: `- [x] Task 1: ...`
- Note deviations inline: `> **Deviation:** Used X instead of Y because [reason]`
- If a task needs splitting, add sub-tasks rather than rewriting
- Never delete plan content — strikethrough or mark as superseded
