---
name: plugin-update
description: "Trigger this skill when the user wants to update the Claude Code Blueprint plugin from GitHub — even if they just say 'update' without specifying what. Trigger when the user says 'update', 'update plugin', 'update blueprint', 'latest version', 'upgrade blueprint', 'new version available', 'check for updates', 'get newest version', 'refresh plugin', or 'reinstall blueprint'. Clones latest from GitHub, copies to cache, and updates the registry. DO NOT TRIGGER for updating project dependencies — use dependency-management instead. DO NOT TRIGGER for migrating from v2.x to v3.0 — use migrate-to-plugin instead."
---

# Plugin Update

Update the blueprint plugin to the latest version from the source GitHub repository.

**Announce at start:** "Updating Claude Code Blueprint plugin..."

## Step 1: Read Current State

Read the current installation state:

```bash
# Get current commit SHA from installed_plugins.json
python3 -c "
import json, os
f = os.path.expanduser('~/.claude/plugins/installed_plugins.json')
with open(f) as fh:
    data = json.load(fh)
entry = data.get('plugins', {}).get('claude-code-blueprint@claude-code-blueprint', [{}])
if isinstance(entry, list):
    entry = entry[0]
print('version:', entry.get('version', 'unknown'))
print('sha:', entry.get('gitCommitSha', 'unknown'))
print('updated:', entry.get('lastUpdated', 'unknown'))
print('path:', entry.get('installPath', 'unknown'))
"
```

Record the current SHA and install path for later comparison.

## Step 2: Clone Latest from GitHub

```bash
TMPDIR=$(mktemp -d)
git clone --depth 1 https://github.com/Ninety2UA/claude-code-blueprint.git "$TMPDIR/blueprint"
NEW_SHA=$(git -C "$TMPDIR/blueprint" rev-parse HEAD)
echo "Latest commit: $NEW_SHA"
```

If the new SHA matches the current SHA, report "Already up to date" and stop.

## Step 3: Show What Changed

If there IS an update, show the user what changed:

```bash
# Get version from plugin.json
cat "$TMPDIR/blueprint/plugins/claude-code-blueprint/.claude-plugin/plugin.json" | python3 -c "import json,sys; print('New version:', json.load(sys.stdin)['version'])"

# Show recent commit messages
git -C "$TMPDIR/blueprint" log --oneline -10
```

## Step 4: Copy Plugin Files to Cache

```bash
CACHE_DIR="$HOME/.claude/plugins/cache/claude-code-blueprint/claude-code-blueprint"
VERSION=$(cat "$TMPDIR/blueprint/plugins/claude-code-blueprint/.claude-plugin/plugin.json" | python3 -c "import json,sys; print(json.load(sys.stdin)['version'])")
DEST="$CACHE_DIR/$VERSION"

# Remove old cached version and copy new
rm -rf "$DEST"
mkdir -p "$DEST"

SOURCE="$TMPDIR/blueprint/plugins/claude-code-blueprint"
for dir in skills agents hooks .claude-plugin scripts templates .claude; do
    if [ -d "$SOURCE/$dir" ]; then
        cp -R "$SOURCE/$dir" "$DEST/$dir"
    fi
done

# Make scripts executable
find "$DEST" -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true

echo "Plugin files updated at $DEST"
```

## Step 5: Update Registry Files

```bash
NEW_SHA=$(git -C "$TMPDIR/blueprint" rev-parse HEAD)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")

# Update known_marketplaces.json
python3 -c "
import json, os
f = os.path.expanduser('~/.claude/plugins/known_marketplaces.json')
with open(f) as fh:
    data = json.load(fh)
data['claude-code-blueprint']['lastUpdated'] = '$TIMESTAMP'
data['claude-code-blueprint']['installLocation'] = '$DEST'
data['claude-code-blueprint']['autoUpdate'] = True
with open(f, 'w') as fh:
    json.dump(data, fh, indent=2)
    fh.write('\n')
"

# Update installed_plugins.json
python3 -c "
import json, os
f = os.path.expanduser('~/.claude/plugins/installed_plugins.json')
with open(f) as fh:
    data = json.load(fh)
key = 'claude-code-blueprint@claude-code-blueprint'
entries = data.get('plugins', {}).get(key, [])
if isinstance(entries, list):
    for entry in entries:
        entry['version'] = '$VERSION'
        entry['lastUpdated'] = '$TIMESTAMP'
        entry['gitCommitSha'] = '$NEW_SHA'
        entry['installPath'] = '$DEST'
else:
    entries['version'] = '$VERSION'
    entries['lastUpdated'] = '$TIMESTAMP'
    entries['gitCommitSha'] = '$NEW_SHA'
    entries['installPath'] = '$DEST'
data['plugins'][key] = entries
with open(f, 'w') as fh:
    json.dump(data, fh, indent=2)
    fh.write('\n')
"

echo "Registry updated"
```

## Step 6: Cleanup and Report

```bash
rm -rf "$TMPDIR"
```

Report to the user:

```
✓ Blueprint updated to v[VERSION] (commit [SHORT_SHA])
  [N] new commits since last update
  Cache: [DEST]

  Restart your Claude session to use the updated plugin.
```

## Important Notes

- This updates the **shared plugin cache** — all projects using the blueprint get the update
- The user must **restart their Claude session** (or start a new one) for changes to take effect
- If the version number changed, the old version directory remains in cache (harmless)
