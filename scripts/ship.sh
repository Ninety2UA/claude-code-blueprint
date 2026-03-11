#!/usr/bin/env bash
# ship.sh — External loop for /ship pipeline (Ralph-style fresh context per iteration)
#
# Spawns a fresh Claude process per iteration, giving each run a clean 200K context.
# State persists via git (commits, branches), plan files, and progress.txt.
# This is the outer loop; ship-loop.sh (Stop hook) is the inner guard against premature exit.
#
# Usage: ./scripts/ship.sh "add user authentication with JWT" [--max N] [--swarm] [--iterations N]
#
# All flags after the feature description are forwarded to /ship.

set -euo pipefail

# ──────────────────────────────────────────────
# Parse arguments
# ──────────────────────────────────────────────
MAX_ITERATIONS=10
FEATURE_PARTS=()
SHIP_FLAGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    --max|--max-iterations)
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --max=*|--max-iterations=*)
      MAX_ITERATIONS="${1#*=}"
      shift
      ;;
    --swarm|--deploy)
      SHIP_FLAGS+=("$1")
      shift
      ;;
    --iterations|--convergence)
      SHIP_FLAGS+=("$1" "$2")
      shift 2
      ;;
    --iterations=*|--convergence=*)
      SHIP_FLAGS+=("$1")
      shift
      ;;
    *)
      FEATURE_PARTS+=("$1")
      shift
      ;;
  esac
done

FEATURE="${FEATURE_PARTS[*]}"

if [[ -z "$FEATURE" ]]; then
  echo "Usage: ./scripts/ship.sh \"<feature description>\" [--max N] [--swarm] [--iterations N] [--convergence fast|deep|perfect]"
  echo ""
  echo "  --max N              Max outer loop iterations (default: 10)"
  echo "  --swarm              Forward to /ship: use parallel team execution"
  echo "  --iterations N       Forward to /ship: max review-improve iterations"
  echo "  --convergence MODE   Forward to /ship: fast|deep|perfect"
  echo ""
  echo "Examples:"
  echo "  ./scripts/ship.sh \"add JWT authentication\""
  echo "  ./scripts/ship.sh \"refactor payments module\" --max 5 --swarm"
  echo "  ./scripts/ship.sh \"add search feature\" --iterations 5 --convergence deep"
  exit 1
fi

# Build the /ship command with all flags
SHIP_CMD="/ship ${FEATURE} --external ${SHIP_FLAGS[*]:-}"

# ──────────────────────────────────────────────
# Progress tracking
# ──────────────────────────────────────────────
PROGRESS_FILE=".claude/ship-progress.local.md"

if [[ ! -f "$PROGRESS_FILE" ]]; then
  cat > "$PROGRESS_FILE" << EOF
# Ship Progress Log
Started: $(date)
Feature: ${FEATURE}
Flags: ${SHIP_FLAGS[*]:-none}
---
EOF
fi

# ──────────────────────────────────────────────
# Main loop — fresh Claude process per iteration
# ──────────────────────────────────────────────
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║  ship.sh — External Loop (Ralph-style)                   ║"
echo "║  Feature: ${FEATURE:0:45}$([ ${#FEATURE} -gt 45 ] && echo '...' || echo '')"
echo "║  Max iterations: ${MAX_ITERATIONS}                                        "
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo ""
  echo "═══════════════════════════════════════════════════════════"
  echo "  Iteration $i of $MAX_ITERATIONS — $(date '+%H:%M:%S')"
  echo "═══════════════════════════════════════════════════════════"
  echo ""

  # Spawn fresh Claude with clean 200K context
  # --print: non-interactive, prints output and exits
  # --dangerously-skip-permissions: autonomous operation (no permission prompts)
  OUTPUT=$(claude --print --dangerously-skip-permissions "$SHIP_CMD" 2>&1 | tee /dev/stderr) || true

  # Check for completion signal
  if echo "$OUTPUT" | grep -q "<promise>DONE</promise>"; then
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  Ship complete! Finished at iteration $i of $MAX_ITERATIONS"
    echo "═══════════════════════════════════════════════════════════"

    # Append final status and clean up
    {
      echo ""
      echo "## Iteration $i — $(date) — COMPLETE"
      echo "Pipeline finished successfully."
      echo "---"
    } >> "$PROGRESS_FILE"

    rm -f "$PROGRESS_FILE"
    exit 0
  fi

  # Log incomplete iteration
  {
    echo ""
    echo "## Iteration $i — $(date)"
    echo "Status: incomplete (context exhausted or premature exit). Continuing with fresh context..."
    echo "---"
  } >> "$PROGRESS_FILE"

  echo ""
  echo "Iteration $i ended without completion. Refreshing context..."
  sleep 2
done

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  Ship reached max iterations ($MAX_ITERATIONS) without completing."
echo "  Check git log and $PROGRESS_FILE for progress."
echo "═══════════════════════════════════════════════════════════"
exit 1
