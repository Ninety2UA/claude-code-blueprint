---
description: "Spawn all research agents in parallel to gather comprehensive context before planning a feature."
argument-hint: "<topic or feature to research>"
---

# /deep-research — Multi-Agent Parallel Research

Spawn a swarm of research agents in parallel, then synthesize their findings into a unified research brief that feeds into `/plan`.

**Announce at start:** "Starting deep research on: $ARGUMENTS"

## Step 1: Define Research Questions

Based on `$ARGUMENTS`, formulate specific research questions for each agent:

1. **What has been done before?** (learnings-researcher)
2. **What do the frameworks/libraries recommend?** (framework-docs-researcher)
3. **What are industry best practices?** (best-practices-researcher)
4. **Why does the current code look this way?** (git-history-analyzer)
5. **What files and dependencies will this change touch?** (codebase-context-mapper)

## Step 2: Dispatch Research Agents in Parallel

Use the Task tool to dispatch ALL research agents simultaneously:

```
Task("learnings-researcher: Search docs/solutions/ and docs/research/ for past work related to [topic]. Report findings with file references.")

Task("framework-docs-researcher: Research the documentation and best practices for [relevant frameworks] related to [topic]. Check installed versions in dependency files.")

Task("best-practices-researcher: Research industry best practices and common patterns for implementing [topic]. Focus on practical, proven approaches.")

Task("git-history-analyzer: Analyze git history for files related to [topic]. Understand why the current code structure exists and what changes have been made previously.")

Task("codebase-context-mapper: Map all files, functions, and integration points that would be affected by implementing [topic]. Produce a focused impact map.")
```

**Important:** Dispatch ALL agents in a single message to maximize parallelism.

## Step 3: Synthesize

When all agents return, dispatch the **research-synthesizer** agent:

```
Task("research-synthesizer: Synthesize these research outputs into one unified brief: [all agent outputs]. Focus on: consensus findings, unique insights, contradictions, and gaps.")
```

## Step 4: Save and Present

Save the synthesized brief to `docs/research/YYYY-MM-DD-[topic-slug].md`.

Present to the user:
- **Key findings** (consensus across agents)
- **Unique insights** (from individual agents)
- **Contradictions** (where agents disagreed)
- **Gaps** (what needs further investigation)
- **Recommended approach** (based on all evidence)

Ask: **"Research complete. Ready to `/plan` based on these findings?"**

If the user confirms, the plan command will automatically pick up the research brief from `docs/research/`.

## When to Use

- Before planning any feature that touches unfamiliar code
- Before making architectural decisions
- When the user says "I want to understand X before building"
- When onboarding to a new area of the codebase
- Before a major refactor or migration

## When NOT to Use

- For small, well-understood changes (use `/quick` instead)
- When you already have a clear plan (go straight to `/plan`)
- For debugging (use `/debug` instead)
