---
description: "Create, manage, or respond to pull requests. Handles the full PR lifecycle."
argument-hint: "[optional: PR title or issue reference]"
---

Read and invoke the pr-workflow skill in .claude/skills/pr-workflow/SKILL.md. Follow it exactly — run tests before creating the PR, self-review the diff, and write a clear description.

If the user provided a title or issue reference, use it: $ARGUMENTS

If no arguments provided, assess the current branch state and determine the appropriate PR action (create, update, or respond to feedback).
