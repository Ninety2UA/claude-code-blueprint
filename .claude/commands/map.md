---
description: "Map an unfamiliar codebase into structured documentation before modifying it."
argument-hint: "[optional: focus area or module name]"
---

Read and invoke the codebase-mapping skill in .claude/skills/codebase-mapping/SKILL.md. Follow it exactly — do NOT modify any source code during mapping. This is a read-only analysis operation.

If the user specified a focus area, scope the mapping to that area: $ARGUMENTS

If no arguments provided, map the full project starting from the root directory.
