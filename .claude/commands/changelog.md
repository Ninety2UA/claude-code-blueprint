---
description: "Generate release notes from git history using Keep a Changelog format."
argument-hint: "[optional: version number or tag range]"
---

Read and invoke the changelog-generation skill in .claude/skills/changelog-generation/SKILL.md. Follow it exactly — categorize commits properly and write user-facing descriptions, not raw commit messages.

If the user specified a version or range, use it: $ARGUMENTS

If no arguments provided, generate the changelog for all commits since the last release tag.
