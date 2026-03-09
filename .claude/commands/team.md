---
description: "Spawn an Agent Team for collaborative multi-file implementation with shared task list and inter-teammate messaging."
argument-hint: "<plan file or task description>"
---

# /team — Collaborative Agent Team

Spawn a team of independent Claude Code instances that coordinate through a shared task list and messaging. Use for complex multi-file implementations where teammates need to discuss and divide work.

**Announce at start:** "Setting up Agent Team for collaborative implementation."

**Prerequisite:** Agent Teams is an experimental feature. Ensure `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS: "1"` is set in your Claude Code settings.json.

## Step 1: Understand the Work

If `$ARGUMENTS` points to a plan file, read it. Otherwise, use the argument as the task description.

Identify:
- What components need to be built or changed
- Which files will be created or modified
- Natural ownership boundaries (by layer, module, or feature area)

## Step 2: Design the Team

Based on the work, determine:

1. **Team size:** 3-5 teammates (see agent-teams skill for sizing guidance)
2. **Responsibility domains:** What each teammate owns
3. **File ownership:** Explicit file assignments (NO overlap)
4. **Task breakdown:** 5-6 tasks per teammate

Present the team design to the user:

```markdown
## Proposed Team

| Teammate | Responsibility | Files Owned |
|----------|---------------|-------------|
| backend | API routes and handlers | src/api/*, src/services/* |
| frontend | UI components and pages | src/components/*, src/pages/* |
| tests | Test suite for new features | tests/*, __mocks__/* |

### Task Breakdown
**backend:** 1. Set up routes, 2. Implement handlers, 3. Add validation, 4. Error handling, 5. Integration with services
**frontend:** 1. Create page skeleton, 2. Build form component, 3. Add API calls, 4. Loading/error states, 5. Polish UI
**tests:** 1. Unit tests for handlers, 2. Unit tests for components, 3. Integration tests, 4. E2E test, 5. Edge cases
```

Ask: **"Approve this team structure? I'll spawn teammates and they'll start working."**

## Step 3: Spawn the Team

For each teammate, use the TeamCreate tool to spawn with a detailed prompt that includes:

1. Their specific responsibility
2. Project conventions (reference `docs/context/CONVENTIONS.md`)
3. Their file ownership list (what they CAN and CANNOT modify)
4. What other teammates are building (for coordination context)
5. Instructions to use the shared task list

**Important:** Include this in every spawn prompt:
```
Read docs/context/CONVENTIONS.md before writing any code.
Use the shared task list to track your progress.
Message the team lead when you complete a major milestone or need a decision.
Wait for dependent tasks from other teammates before starting dependent work.
```

## Step 4: Monitor and Steer

While the team works:

1. Watch for idle notifications (teammates finishing their tasks)
2. Check task list progress periodically
3. Intervene if a teammate is stuck or going in the wrong direction
4. Relay information between teammates when needed
5. Resolve design questions that require cross-team decisions

**Tell the team lead session:** "Wait for your teammates to complete their tasks before proceeding."

## Step 5: Verify and Review

When all teammates complete:

1. Check the shared task list — all tasks should be `completed`
2. Run the full test suite to verify everything works together
3. Run build and lint checks
4. Dispatch `/review-swarm` on the combined changes for quality review

## Step 6: Report

```markdown
## Agent Team Complete

### Team Performance
| Teammate | Tasks | Status | Files Changed |
|----------|-------|--------|---------------|
| backend | 5/5 | Complete | [list] |
| frontend | 5/5 | Complete | [list] |
| tests | 5/5 | Complete | [list] |

### Integration
- Tests: [X passing, Y failing]
- Build: [pass/fail]
- Lint: [pass/fail]

### Next Steps
- [ ] Run /review-swarm for quality review
- [ ] Address any review findings
- [ ] Create PR
```

## When NOT to Use /team

- **Small changes (< 3 files):** Use direct implementation or `/quick`
- **Analysis/review tasks:** Use `/review-swarm` or `/deep-research` (swarm pattern)
- **Strictly sequential work:** Use `/orchestrate` (wave pattern)
- **Single-layer changes:** A single subagent is sufficient
