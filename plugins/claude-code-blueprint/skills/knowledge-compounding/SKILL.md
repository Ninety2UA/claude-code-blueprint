---
name: knowledge-compounding
description: Use after solving a non-trivial problem to document the problem, approach, and solution as institutional knowledge that future planning can search and learn from
---

# Knowledge Compounding

## Overview

Each solved problem should make future problems easier. This skill captures solved problems as structured documents in `docs/solutions/`, creating a searchable knowledge base that the learnings-researcher agent and `/plan` command automatically consult.

**Core principle:** Solve a problem once; benefit every time a similar problem arises.

## When to Use

- After solving a non-trivial bug (not typos or config fixes)
- After implementing a pattern that could be reused
- After discovering a framework gotcha or version-specific behavior
- After a debugging session that uncovered a non-obvious root cause
- After making an architectural decision with significant trade-offs
- When the user says `/compound` or "document this for future reference"

**Don't use for:**
- Trivial fixes (typos, import corrections)
- One-off config changes
- Changes that are already well-documented in framework docs

## Process

### Step 1: Identify the Knowledge

Ask yourself:
1. **What problem was solved?** (The symptom and root cause)
2. **What approach worked?** (The solution, not just the fix)
3. **What did we try that didn't work?** (Failed approaches save future time)
4. **What would we do differently?** (Retrospective insight)
5. **When would this apply again?** (Searchable keywords)

### Step 2: Write the Solution Document

Create `docs/solutions/YYYY-MM-DD-[slug].md`:

```markdown
---
title: [Descriptive title]
date: YYYY-MM-DD
tags: [technology, pattern, domain]
applies-to: [what part of the codebase or what type of work]
---

# [Title]

## Problem

[What went wrong or what needed to be built. Include error messages, symptoms, or requirements. Be specific enough that someone searching for this problem would find it.]

## Root Cause

[Why the problem occurred. The underlying mechanism, not just "it was broken."]

## Solution

[What was done to fix it. Include code snippets, configuration changes, or architectural decisions. Be specific and reproducible.]

## What Didn't Work

[Approaches that were tried and failed, and why. This prevents future developers from repeating dead ends.]

- **[Approach 1]:** [Why it failed]
- **[Approach 2]:** [Why it failed]

## Key Insight

[The one-sentence takeaway. What should someone remember from this?]

## Applicability

[When would this knowledge be relevant again? What search terms would someone use?]

- Relevant when: [conditions]
- Technology: [framework/library/tool]
- Pattern: [design pattern or architectural pattern]
```

### Step 3: Cross-Reference

Check if this solution relates to:
- Existing docs in `docs/solutions/` — add cross-references
- Architecture decisions in `docs/decisions/` — link if relevant
- Key Learnings in `CLAUDE.md` — add a one-line entry if broadly applicable

### Step 4: Verify Searchability

Ensure the document can be found by the learnings-researcher agent:
- Title contains the key technology or pattern name
- Tags cover the relevant domains
- Problem description includes the error message or symptom text
- "Applies-to" field matches how future planners would describe the area

### Step 5: Confirm

Tell the user:
```
Knowledge compounded: docs/solutions/[filename]
Tags: [tags]
Future /plan and /deep-research commands will find this automatically.
```

## How This Integrates with Other Skills

| Skill/Command | How It Uses Solutions |
|---------------|---------------------|
| `/plan` (build Stage 3) | learnings-researcher searches `docs/solutions/` before planning |
| `/deep-research` | learnings-researcher includes solutions in research brief |
| `/build` | Automatically runs `/compound` after Stage 6 if a non-trivial problem was solved |
| `/wrap` | Reminds to compound if significant debugging or problem-solving occurred |

## Quality Bar

A good solution document:
- Can be found by searching for the error message or technology name
- Explains WHY, not just WHAT
- Includes failed approaches (saves the most time)
- Is specific enough to be actionable, not so specific it's a one-off
- Takes 2-5 minutes to write (not a research paper)

A bad solution document:
- Just says "fixed the bug by changing X to Y"
- Has no context about why the bug occurred
- Is so generic it's not actionable
- Duplicates framework documentation

## Common Mistakes

**Documenting too little** — "Fixed it" is not a solution document. Include the root cause and approach.

**Documenting too much** — This is not a blog post. 50-100 lines is ideal. If it's longer, you're writing a research doc.

**Missing search terms** — If the document doesn't include the error message or symptom, it won't be found when someone encounters the same problem.

**Skipping failed approaches** — The approaches that DIDN'T work are often more valuable than the one that did. They prevent future time waste.
