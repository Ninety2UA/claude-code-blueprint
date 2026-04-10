---
name: iterative-refinement
description: "Trigger this skill when code needs repeated review-fix-review cycles until quality converges, when the user says 'iterate on quality', 'keep improving until clean', 'review loop', 'polish this', 'iterate until done', or 'refinement cycles'. Usually invoked by pipeline skills (ship-pipeline, build-pipeline) rather than directly, but also trigger when the user wants to go beyond a single review pass for production-quality output. Supports three convergence modes: fast (zero P1), deep (zero P1+P2), and perfect (zero findings). Dispatches review swarm, resolves findings, verifies fixes, checks for convergence, and repeats up to max iterations. Includes deslop pass (Step 0.5) to clean AI-generated text patterns before review begins."
---

# Iterative Refinement

## Overview

Dispatch repeated review→fix→review cycles to iteratively improve code quality. Each iteration runs the full review swarm, resolves findings, verifies fixes, and checks for convergence. The loop exits when quality is sufficient or max iterations reached.

**Core principle:** One review pass catches most issues. Two catches the fixes that introduced new issues. Three confirms convergence. Beyond that, diminishing returns.

## When to Use

- After implementing a feature — iterate to production quality
- When `/ship` reaches the review stage — automated quality improvement
- When `/build --iterate N` is invoked — add iteration to the supervised pipeline
- When you want to polish code beyond a single review pass

**Don't use when:**
- The change is trivial (< 3 files, simple logic) — a single `/review-swarm` is sufficient
- You haven't implemented anything yet — review needs code to review
- Review findings require architectural changes — stop and re-plan instead

## Configuration

| Parameter | Default | Range | Override |
|-----------|---------|-------|----------|
| `max_iterations` | 3 | 1-10 | User specifies or calling command passes |
| `convergence` | `fast` | `fast`, `deep`, `perfect` | User specifies |

**Convergence modes:**

| Mode | Exit When | Best For |
|------|-----------|----------|
| **fast** (default) | P1 count = 0 | Most features — catches critical issues |
| **deep** | P1 + P2 count = 0 | Important features — catches all significant issues |
| **perfect** | P1 + P2 + P3 = 0 | High-stakes (auth, payments, data migrations) |

## Process

### Step 0: Initialize

Determine the iteration parameters:
- `max_iterations`: from caller or user (default 3)
- `convergence`: from caller or user (default `fast`)
- `scope`: what to review (diff, branch, specific files)

Initialize tracking:
```markdown
## Iterative Refinement — Starting
- Max iterations: [N]
- Convergence mode: [fast|deep|perfect]
- Scope: [description]
```

### Step 0.5: Deslop Pass

Before dispatching reviewers, scan all changed files for AI-generated text patterns and clean them:

**Detect and remove:**
- Over-hedged language ("it's worth noting that", "it should be mentioned", "importantly")
- Filler transitions ("Let's", "Now let's", "Moving on to")
- Comments that restate what the code does (`// increment counter` above `counter++`)
- Docstrings that add no information beyond the function signature
- Unnecessary type annotations on variables with obvious types (where the language has inference)
- Over-verbose error messages that repeat the function name
- Redundant null checks already guaranteed by the type system

**Preserve:**
- Comments explaining WHY (business logic, edge case rationale, workarounds)
- Documentation on public APIs
- Type annotations that clarify non-obvious types

**Process:** Read each changed file, apply deslop fixes via Edit, then verify tests still pass. If a deslop change breaks tests, revert that specific change.

### Step 1: Enter the Refinement Loop

```
┌──────────────────────────────────────────────────┐
│           ITERATIVE REFINEMENT LOOP              │
│                                                  │
│  ┌──► Dispatch /review-swarm                     │
│  │         │                                     │
│  │    Collect findings (P1/P2/P3 counts)         │
│  │         │                                     │
│  │    ┌────┴──────────┐                          │
│  │    │ Converged?    │                          │
│  │    │ (per mode)    │                          │
│  │    └────┬──────────┘                          │
│  │   yes   │   no                                │
│  │         │    │                                │
│  │   EXIT  │    Dispatch resolve-in-parallel     │
│  │  (done) │    for qualifying findings          │
│  │         │         │                           │
│  │         │    Run tests + build                │
│  │         │         │                           │
│  │         │    ┌────┴─────┐                     │
│  │         │    │ Tests OK? │                    │
│  │         │    └────┬─────┘                     │
│  │         │   yes   │   no                      │
│  │         │         │   Debug + fix             │
│  │         │         │                           │
│  │         │    Commit fixes                     │
│  │         │         │                           │
│  │         │    iteration++                      │
│  │         │         │                           │
│  │         │    ┌────┴────────────┐              │
│  │         │    │ < max_iterations? │            │
│  │         │    └────┬────────────┘              │
│  │         │   yes   │   no                      │
│  │         │         │                           │
│  └─────────┘    MAX REACHED                      │
│                 (report remaining findings)       │
└──────────────────────────────────────────────────┘
```

### Step 2: Each Iteration

For each iteration `i` of `max_iterations`:

#### 2a. Review

Announce: "Refinement iteration [i]/[max] — dispatching review swarm."

Invoke the `/review-swarm` command (via the Skill tool if available, or by following the review-swarm command instructions directly). This dispatches all configured review agents in parallel and synthesizes findings. Collect the synthesized findings with P1/P2/P3 counts.

#### 2b. Check Convergence

Evaluate against the convergence mode:

| Mode | Condition to EXIT | Condition to CONTINUE |
|------|-------------------|-----------------------|
| `fast` | P1 = 0 | P1 > 0 |
| `deep` | P1 + P2 = 0 | P1 + P2 > 0 |
| `perfect` | P1 + P2 + P3 = 0 | Any findings remain |

If converged:
```markdown
## Refinement Converged — Iteration [i]/[max]
- P1: 0 | P2: [n] | P3: [n]
- Convergence mode: [mode] — criteria met
- Total iterations used: [i]
```
EXIT the loop. Proceed to Step 3.

If NOT converged, continue to 2c.

#### 2c. Resolve Findings

Separate findings into resolution groups:

1. **Independent findings** (different files, no shared state) → read and invoke the resolve-in-parallel skill to fix concurrently
2. **Dependent findings** (same file or shared state) → resolve sequentially

For each resolution:
- Fix the specific issue identified
- Do NOT make unrelated changes
- Do NOT introduce new patterns or refactors beyond the finding

#### 2d. Verify

Run the full test suite and build:
```bash
[test command]
[build command]
```

If tests fail:
- Use systematic-debugging skill to identify the cause
- Fix the regression
- Re-run tests until passing
- If unable to fix after 2 attempts, revert the problematic fix and mark that finding as "deferred"

#### 2e. Commit

Commit all fixes from this iteration:
```
fix: address review findings (iteration [i]/[max])
```

#### 2f. Progress Report

After each iteration, report:
```markdown
## Iteration [i]/[max] Complete

### Findings This Round
- P1 (critical): [count] found, [count] fixed, [count] deferred
- P2 (important): [count] found, [count] fixed, [count] deferred
- P3 (suggestions): [count] found, [count] noted

### Cumulative Progress
| Iteration | P1 | P2 | P3 | Action |
|-----------|----|----|-----|--------|
| 1 | [n] | [n] | [n] | Fixed [n] findings |
| 2 | [n] | [n] | [n] | Fixed [n] findings |
| ... | | | | |

### Next
- [Continuing to iteration i+1] OR [Converged — exiting loop]
```

### Step 3: Final Report

When the loop exits (either converged or max reached):

```markdown
## Iterative Refinement Complete

### Summary
- Iterations used: [i] of [max]
- Exit reason: [Converged (P1=0) | Max iterations reached]
- Convergence mode: [fast|deep|perfect]

### Quality Trajectory
| Iteration | P1 | P2 | P3 | Fixes Applied |
|-----------|----|----|-----|---------------|
| 1 | [n] | [n] | [n] | [n] |
| 2 | [n] | [n] | [n] | [n] |
| 3 | [n] | [n] | [n] | [n] |

### Remaining Findings (if max reached without convergence)
- P1: [list any remaining critical issues]
- P2: [list any remaining important issues]

### Deferred Findings (fixes that caused regressions)
- [list any findings that were reverted]
```

If max iterations reached with P1 > 0, this is a **warning** — critical issues remain unresolved. The calling workflow should stop and escalate to the user with a structured report:

```markdown
## Escalation — Refinement Did Not Converge

### Unresolved Issues
- [list each remaining P1/P2 with file:line and description]

### Reviewer Perspectives
- **[Agent A]** recommends: [approach]
- **[Agent B]** recommends: [approach]
- [Include all reviewers who weighed in on the unresolved issues]

### My Recommendation
[Which approach to take and why, based on project conventions and architectural context]

### Options
A. [Fix approach 1] — [tradeoff]
B. [Fix approach 2] — [tradeoff]
C. Merge as-is with known issues tracked in BACKLOG.md
```

Present both the reviewers' perspectives AND your recommendation — don't just dump a findings list.

## Integration with Other Skills

| Situation | What Happens |
|-----------|-------------|
| Called by `/ship` | Runs after execution, default 3 iterations, fast convergence |
| Called by `/build --iterate N` | Replaces single-pass review (Stage 5) with N-iteration loop |
| Called standalone | User invokes directly for iterative polish |
| Finding requires architecture change | EXIT loop, report blocker, escalate to user |
| All findings are P3 in fast mode | Converged — P3s are suggestions, not blockers |

## Anti-Patterns

**Re-reviewing unchanged code** — If iteration N finds the same findings as iteration N-1 with zero fixes applied, STOP. The findings are unfixable by automated resolution and need human input.

**Oscillating fixes** — If fixing finding A breaks finding B, and fixing B breaks A, STOP. This indicates a design issue that review-and-fix cannot resolve.

**Scope creep in fixes** — Each fix should address exactly one finding. Do not "improve" surrounding code while fixing a finding. Scope creep in fixes creates new findings, preventing convergence.

**Ignoring test failures** — Never commit a fix that breaks tests. Revert and defer the finding instead.

## Quick Reference

| Scenario | Recommended Config |
|----------|-------------------|
| Standard feature | 3 iterations, fast convergence |
| Auth/security feature | 5 iterations, deep convergence |
| Data migration | 5 iterations, deep convergence |
| Payment/billing code | 10 iterations, perfect convergence |
| Quick bug fix | 1 iteration, fast convergence (essentially a single review) |
