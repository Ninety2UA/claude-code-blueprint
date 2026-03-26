---
name: pr-workflow
description: Use when creating a pull request, responding to PR review feedback, or managing the PR lifecycle from creation through merge
---

# PR Workflow

## Overview

End-to-end pull request lifecycle — from creating a well-structured PR through self-review, handling feedback, and resolving individual comments.

## When to Use

- Creating a new pull request
- Self-reviewing before requesting human review
- Processing reviewer feedback on an existing PR
- Resolving individual PR comments efficiently

## The Iron Law

<HARD-GATE>
Do NOT create a PR without first verifying that all tests pass. Run the test suite and confirm green before opening the PR.
</HARD-GATE>

## Process

### Phase 1: Creating the PR

#### Step 1: Pre-flight Check

Before creating the PR:
```bash
# Ensure all tests pass
[test command]

# Ensure build succeeds
[build command]

# Review your own diff
git diff main...HEAD --stat
git diff main...HEAD
```

#### Step 2: Write the PR

Create the PR with:
- **Title:** Concise, imperative mood (`Add user authentication`, not `Added user auth`)
- **Description:** What changed, why, and how to test it
- **Linked issues:** Reference any issues this closes

PR description template:
```markdown
## What
[One-paragraph summary of the change]

## Why
[Motivation — what problem does this solve?]

## How
[Brief technical approach — not a code walkthrough, but the key design decisions]

## Testing
[How to verify this works — specific steps or test commands]

## Checklist
- [ ] Tests pass
- [ ] No new warnings
- [ ] Documentation updated (if applicable)
- [ ] Migration reversible (if applicable)
```

#### Step 3: Self-Review

Before requesting review, review your own PR as if you were a reviewer:
- Read every line of the diff
- Check for debugging artifacts (console.log, TODO, commented-out code)
- Verify naming consistency
- Check for missing error handling
- Ensure test coverage for new code paths

### Phase 2: Handling Feedback

When review comments arrive:

#### Step 1: Read All Comments First

Read every comment before making any changes. Understand the full picture — some comments may conflict or depend on each other.

#### Step 2: Triage Comments

Categorize each comment:
- **Will fix:** Clear, valid feedback — fix it
- **Needs discussion:** Disagreement or ambiguity — respond with your reasoning
- **Won't fix (with reason):** Comment is based on a misunderstanding — explain politely

#### Step 3: Resolve Comments

For independent comments, dispatch **pr-comment-resolver** agents in parallel (one per comment) using the dispatching-parallel-agents skill.

For dependent comments (where fixing one affects another), resolve them sequentially.

#### Step 4: Push and Respond

After all fixes are applied:
```bash
# Run tests again
[test command]

# Push the fixes
git push
```

Respond to each comment thread indicating how it was addressed.

### Phase 3: Merging

After approval:
1. Rebase onto the latest main (if needed)
2. Verify tests still pass after rebase
3. Squash or merge per project convention
4. Delete the feature branch

## Quick Reference

| Situation | Action |
|-----------|--------|
| Creating PR | Pre-flight → Write → Self-review |
| Received feedback | Read all → Triage → Resolve → Push |
| Single comment to fix | Dispatch pr-comment-resolver agent |
| Multiple independent comments | Dispatch parallel pr-comment-resolver agents |
| Ready to merge | Rebase → Test → Merge → Delete branch |

## Common Mistakes

**Pushing without testing** — Always run tests after making review fixes. A "simple rename" can break things.

**Responding defensively** — Treat review comments as gifts. If you disagree, explain your reasoning calmly with evidence.

**Giant PRs** — Keep PRs under 400 lines of diff. If larger, split into stacked PRs or break the feature into increments.

**Fixing unrelated things** — Don't add "while I'm here" fixes to a PR. They muddy the review and increase risk. Create a separate PR.
