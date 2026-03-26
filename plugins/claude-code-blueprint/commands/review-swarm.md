---
description: "Dispatch all configured review agents in parallel for comprehensive multi-perspective code review."
argument-hint: "[optional: specific files or scope to review]"
---

# /review-swarm — Multi-Agent Parallel Review

Dispatch a swarm of specialized review agents in parallel, then synthesize their findings into one prioritized report.

**Announce at start:** "Starting review swarm — dispatching specialized reviewers in parallel."

## Step 1: Determine Scope

Identify what to review:
- If `$ARGUMENTS` specifies files or scope, use that
- Otherwise, review uncommitted changes (`git diff`) or the last commit (`git diff HEAD~1`)
- For a PR review, use `git diff main...HEAD`

## Step 2: Load Project Configuration

Check if `blueprint.local.md` exists in the project root. If it does, read the `review-agents` list from its YAML frontmatter to determine which agents to dispatch. If it doesn't exist, use the default set.

**Default review agents:**
- **code-reviewer** — plan alignment, code quality, architecture
- **security-sentinel** — vulnerabilities, auth, secrets, OWASP
- **performance-oracle** — bottlenecks, complexity, scaling
- **code-simplicity-reviewer** — YAGNI, over-engineering
- **convention-enforcer** — project conventions compliance
- **test-coverage-reviewer** — test quality and behavioral coverage

**Additional agents (dispatch if changes touch these areas):**
- **architecture-strategist** — if structural changes or new services added
- **frontend-reviewer** — if UI/CSS/component changes
- **data-integrity-guardian** — if migrations or schema changes
- **schema-drift-detector** — if schema.rb/migration files changed

## Step 3: Prepare Review Context

For each agent, prepare a focused prompt that includes:
1. The diff or file list to review
2. Relevant project conventions from `docs/context/CONVENTIONS.md`
3. The agent's specific focus area
4. Instructions to report findings with severity, file:line location, and fix recommendation

## Step 4: Dispatch All Agents in Parallel

Use the Task tool to dispatch all selected agents simultaneously. Each agent gets an independent 200K context window.

```
Task("security-sentinel: Review [scope] for security issues. [diff/files]. Report findings as P1/P2/P3.")
Task("performance-oracle: Review [scope] for performance issues. [diff/files]. Report findings as P1/P2/P3.")
Task("code-reviewer: Review [scope] against plan and standards. [diff/files]. Report findings as P1/P2/P3.")
... (all agents in parallel)
```

**Important:** Dispatch ALL agents in a single message to maximize parallelism.

## Step 5: Collect and Synthesize

When all agents return, dispatch the **findings-synthesizer** agent with all outputs:

```
Task("findings-synthesizer: Synthesize these review outputs into one prioritized report: [all agent outputs]")
```

The synthesizer will:
- De-duplicate overlapping findings
- Assign final P1/P2/P3 priorities
- Group by file for easy resolution
- Recommend fix order

## Step 6: Present Results

Present the synthesized report to the user. Highlight:
- P1 count (must fix before merge)
- P2 count (should fix)
- P3 count (suggestions)

Ask: **"Would you like me to resolve these findings? I can dispatch agents in parallel to fix independent issues."**

If the user says yes, read and invoke the resolve-in-parallel skill to fix independent findings concurrently.

## Quick Reference

| Flag | Behavior |
|------|----------|
| `/review-swarm` | Review uncommitted changes or last commit |
| `/review-swarm --pr` | Review all changes on current branch vs main |
| `/review-swarm src/auth/` | Review only files in src/auth/ |
| `/review-swarm --full` | Dispatch ALL agents including optional ones |
