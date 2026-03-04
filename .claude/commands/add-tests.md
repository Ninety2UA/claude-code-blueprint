---
description: "Analyze test coverage gaps and generate tests for untested code paths."
argument-hint: "[optional: file or module to analyze]"
---

# /add-tests — Test Gap Analysis and Generation

## Step 1: Analyze Gaps

Dispatch the **test-gap-analyzer** agent to analyze coverage:

```
Task: Analyze test coverage for [target].
Focus on: [specific module if provided, otherwise the most recently changed files]
Return: Prioritized list of untested code paths with generated test code.
```

Target: $ARGUMENTS

If no target specified, analyze the files changed in the last 5 commits:
```bash
git diff --name-only HEAD~5 HEAD | grep -v test | grep -v spec
```

## Step 2: Review Findings

Present the agent's findings to the user:
- Critical gaps (untested error paths, security-related code)
- High-priority gaps (core business logic)
- Medium/low gaps (utilities, helpers)

Ask: **"Which gaps should I fill? All critical+high, or specific ones?"**

## Step 3: Generate Tests

For each approved gap, use the test-driven-development skill in `.claude/skills/test-driven-development/SKILL.md` to write behavioral tests:
- Follow existing test conventions exactly
- Use Arrange-Act-Assert pattern
- Include both positive and negative cases

## Step 4: Verify

```bash
# Run all tests including new ones
[test command]
```

All tests must pass — both new and existing.
