---
description: "Comprehensive project health check — build, tests, lint, deps, conventions, docs, backlog, git."
---

# /health — Project Health Check

Run a comprehensive health assessment across all project dimensions. Report findings and flag items that need attention.

## Checks (run as many in parallel as possible)

### 1. Build Status
```bash
[build command from CONVENTIONS.md]
```
**Pass:** Build completes without errors or warnings
**Fail:** Note the error/warning output

### 2. Test Status
```bash
[test command from CONVENTIONS.md]
```
**Pass:** All tests pass, note total count
**Fail:** List failing tests by name

### 3. Lint Status
```bash
[lint command from CONVENTIONS.md]
```
**Pass:** No lint errors or warnings
**Fail:** Note error count and most common categories

### 4. Dependency Health
```bash
# Check for outdated dependencies (npm/yarn/pip/etc.)
[outdated command]

# Check for known vulnerabilities
[audit command]
```
**Pass:** No critical/high vulnerabilities, deps reasonably current
**Fail:** List critical vulnerabilities and severely outdated deps

### 5. Convention Compliance

Read `docs/context/CONVENTIONS.md`. Spot-check the 5 most recently changed files against the conventions. Note any violations.

### 6. Documentation Freshness

Check if key docs are up to date:
```bash
# When were context docs last modified?
ls -la docs/context/STATUS.md docs/context/GOALS.md docs/context/CONVENTIONS.md 2>/dev/null

# When was CLAUDE.md Session Continuity last updated?
grep "Last session:" CLAUDE.md
```
**Pass:** Docs updated within last 7 days
**Warning:** Docs older than 7 days
**Fail:** Key docs missing

### 7. Backlog Health

Read `BACKLOG.md`:
- Count items in Inbox (untriaged)
- Count items in Triaged
- Flag any P0/critical items not being worked on

### 8. Git Health
```bash
# Uncommitted changes
git status --short

# Unpushed commits
git log @{u}..HEAD --oneline 2>/dev/null

# Stale branches
git branch --merged main | grep -v main | grep -v '*'
```

## Report Format

```markdown
## Project Health Report

| Area | Status | Details |
|------|--------|---------|
| Build | ✅/⚠️/❌ | [brief note] |
| Tests | ✅/⚠️/❌ | [X passing, Y failing] |
| Lint | ✅/⚠️/❌ | [error count] |
| Dependencies | ✅/⚠️/❌ | [vulns/outdated count] |
| Conventions | ✅/⚠️/❌ | [violations found] |
| Documentation | ✅/⚠️/❌ | [freshness] |
| Backlog | ✅/⚠️/❌ | [untriaged count] |
| Git | ✅/⚠️/❌ | [uncommitted/unpushed] |

### Items Needing Attention
1. [Most critical finding]
2. [Second finding]
3. [Third finding]

### Recommended Next Actions
1. [First action]
2. [Second action]
```

Present the report and ask: **"Want me to address any of these findings?"**
