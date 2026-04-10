---
description: "Migrate from blueprint v2.x (in-project files) to v3.0 (plugin mode). Removes engine files, keeps project state."
---

# /migrate-to-plugin — Blueprint v2.x → v3.0 Migration

This command migrates a project from the v2.x install-script model (engine files copied into the project) to the v3.0 plugin model (engine files provided by the plugin, only project state in-project).

**Announce at start:** "Starting migration from blueprint v2.x to plugin mode."

## Step 1: Verify Plugin Is Installed

Check that the blueprint plugin is available by verifying you can access blueprint skills (e.g., the brainstorming skill). If the plugin is NOT installed:

```
STOP. The blueprint plugin must be installed first.
Run: curl -fsSL https://raw.githubusercontent.com/Ninety2UA/claude-code-blueprint/main/install.sh | bash
Then re-run /migrate-to-plugin.
```

## Step 2: Detect In-Project Engine Files

Check for v2.x engine files in the project:

```bash
ls .claude/commands/ 2>/dev/null | head -3
ls .claude/skills/ 2>/dev/null | head -3
ls .claude/agents/ 2>/dev/null | head -3
ls .claude/hooks/ 2>/dev/null | head -3
ls hooks/hooks.json 2>/dev/null
ls .claude-plugin/plugin.json 2>/dev/null
```

If NONE of these directories exist, report: "No v2.x engine files found. This project is already in plugin mode or was never installed." and stop.

## Step 3: Check for Local Modifications

For each engine file found, check if it has been modified from the template:

```bash
git status .claude/commands/ .claude/skills/ .claude/agents/ .claude/hooks/ hooks/ .claude-plugin/ 2>/dev/null
git diff --stat HEAD -- .claude/commands/ .claude/skills/ .claude/agents/ .claude/hooks/ 2>/dev/null
```

If any engine files have been locally modified:
- List the modified files
- Ask: "These files have local modifications. They will be REMOVED during migration (the plugin version will be used instead). Do you want to: (a) Back up modified files to `.claude/custom-overrides/` before removing, or (b) Remove them (plugin versions are identical to the template)?"
- Wait for user confirmation before proceeding

## Step 4: Create Backup Branch

```bash
git stash push -m "pre-migration-stash" 2>/dev/null || true
git checkout -b blueprint-v2-backup 2>/dev/null || true
git checkout - 2>/dev/null || true
```

Report: "Backup branch `blueprint-v2-backup` created at current HEAD."

## Step 5: Remove Engine Files

Remove the following directories/files that are now provided by the plugin:

```bash
# Engine directories
rm -rf .claude/commands/
rm -rf .claude/skills/
rm -rf .claude/agents/
rm -rf .claude/hooks/

# Plugin/hook config (now in plugin)
rm -rf .claude-plugin/
rm -rf hooks/

# Settings (now in plugin)
rm -f .claude/settings.json

# Clean up empty .claude/ if nothing remains
rmdir .claude/ 2>/dev/null || true
```

## Step 6: Keep Project State Files

Verify these files still exist (they should NOT have been removed):
- `CLAUDE.md`
- `BACKLOG.md`
- `blueprint.local.md`
- `docs/context/CONVENTIONS.md`
- `docs/context/GOALS.md`
- `docs/context/STATUS.md`
- `docs/plans/`
- `docs/solutions/`
- `docs/learnings/`
- `docs/decisions/`
- `docs/research/`
- `docs/specs/`

If any are missing, report them as a warning.

## Step 7: Verify Plugin Commands Work

Quick verification: invoke the brainstorming skill to confirm the plugin is providing engine files correctly.

## Step 8: Report

```
Migration complete! v2.x → v3.0 (plugin mode)

Removed:
  .claude/commands/    (27 files → now from plugin)
  .claude/skills/      (35 dirs → now from plugin)
  .claude/agents/      (26 files → now from plugin)
  .claude/hooks/       (6 files → now from plugin)
  .claude-plugin/      (plugin manifest → now from plugin)
  hooks/               (hook config → now from plugin)

Kept:
  CLAUDE.md, BACKLOG.md, blueprint.local.md
  docs/ (all project state)

Backup: branch `blueprint-v2-backup`

Next: Commit this cleanup with `git add -A && git commit -m "chore: migrate to blueprint plugin v3.0"`
```
