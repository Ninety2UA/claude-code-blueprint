---
title: "Decision record: /goal cannot replace the ship-loop guard — kept as complement (rebuild attempted → reverted)"
date: 2026-07-17
category: gate-decision
cycle: platform-sync-2026-07-17
requirement: R2 (candidate a), R4, R6, R17, AE5, KTD-1, KTD-2, KTD-10
applies_when:
  - Evaluating whether native /goal should replace the ship-pipeline Stop-hook guard
  - Any future audit re-flagging ship-loop.sh as duplicating native condition-completion
  - Deciding whether a core pipeline may depend on a user-typed slash command
tags: [gate-decision, ship-loop, goal, rebuild-lifecycle, platform-sync, ae5]
---

# /goal vs the ship-loop guard — rebuild attempted, reverted, kept as complement

**Gate 1 outcome:** the maintainer approved *attempting* the rebuild (R2 candidate a) under the
plan's keep-old-until-pass lifecycle (KTD-2). Implementation-time evidence showed the replacement
cannot pass behavioral verification without regressing an existing guarantee, so per KTD-2 / R4 /
AE5 the rebuild **reverts**: `ship-loop.sh` stays byte-identical and active, and native `/goal` is
adopted as an **opt-in complement** instead of a replacement.

## What was attempted

Replace `plugins/claude-code-blueprint/hooks/handlers/ship-loop.sh` (the `/ship` inner Stop-hook
guard against premature exit) with the platform-native `/goal` condition-based completion
(GA in CLI 2.1.139).

## Why it cannot replace (the failing scenario — AE5)

1. **A skill/hook cannot invoke `/goal`.** `/goal` is a top-level *user-typed* command. Verified
   two ways: no goal tool exists anywhere in the Claude Code toolset (ToolSearch for
   goal/completion primitives returns none), and the compound-engineering plugin's own
   `ce-work/references/execution-engines.md` states it plainly ("No goal tools exposed. `/goal` is a
   top-level user command only; a skill cannot invoke it"). So `/ship` (a skill) cannot start a goal
   on the user's behalf.
2. **`ship-loop.sh` guards automatically, with zero user action, in every mode.** It is a Stop hook
   reading stdin — it fires in interactive **and** headless `--external` (`scripts/ship.sh` spawning
   `claude -p` per iteration) runs where no human is present. Behavioral baseline drive: 6/6
   behaviors pass (blocks premature exit + re-feeds; releases on `<promise>DONE</promise>` and
   cleans state; honors the iteration cap; isolates by session; no-op when inactive; atomic
   iteration increment).
3. Therefore a `/goal` replacement would leave headless `/ship` — and any interactive user who
   simply runs `/ship` without also typing `/goal` — with **no premature-exit guard at all**. That
   is exactly AE5: "the `/goal`-based guard fails to block a premature exit that `ship-loop.sh`
   would have blocked." A retry cannot fix it; the constraint is architectural, not an
   implementation bug.

## Precedent that settled the shape (compound-engineering v3.19.0)

CE hit the identical wall for its own engine and resolved it by **emitting a copyable `/goal`
prompt the user pastes**, treated as strictly best-effort: "print a copyable prompt block for the
user to paste, then continue inline/subagents if the user does not paste it. Do not stall waiting
for a paste." In headless/return-to-caller mode it does **not** emit the prompt at all ("a manual
paste step strands the caller. Run inline/subagents instead"). The load-bearing principle: never
depend on the paste; always keep a fallback that does the real work. Applied to `/ship`, that
fallback *is* `ship-loop.sh` — so CE's own pattern both prescribes the complement shape and refutes
removal.

## Decision (kept)

- `ship-loop.sh` and the `hooks.json` Stop entry: **unchanged, byte-identical** — the default,
  zero-config, headless-compatible guard.
- `skills/ship-pipeline/SKILL.md`: interactive Stage 0 now **optionally emits a copyable `/goal`
  prompt** (CLI v2.1.139+) for overlay-visible native condition-completion, explicitly non-blocking
  and never emitted under `--external`. `/goal` is a convenience, **not** a dependency — so **R6 is
  satisfied** (the core pipeline depends only on the always-available Stop hook) and **R17 does not
  fire** (no minimum-CLI floor is imposed on `/ship`).
- Native `STOP_HOOK_BLOCK_CAP` (default 8, CLI 2.1.143) is noted as a backstop against runaway
  blocking — defense in depth.

## Version consequence (KTD-10)

No custom machinery was removed and no rebuild shipped, so **Part 1 is a minor release, not the
major (v4.0.0) that a shipped rebuild would have triggered.**
