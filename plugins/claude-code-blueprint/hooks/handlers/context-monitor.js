#!/usr/bin/env node
/**
 * PostToolUse Hook — Context Window Monitor & Analysis Paralysis Guard.
 * Tracks tool calls and warns agent when context may be running low
 * or when consecutive read-only operations indicate analysis paralysis.
 */

const fs = require('fs');
const path = require('path');
const os = require('os');

const cwd = process.cwd();
const stateDir = path.join(os.tmpdir(), 'claude-blueprint');
const stateFile = path.join(stateDir, 'ctx-' + Buffer.from(cwd).toString('hex').slice(0, 16) + '.json');

// Load state
let state = { calls: 0, reads: 0 };
try {
  state = JSON.parse(fs.readFileSync(stateFile, 'utf-8'));
} catch (e) { /* fresh state */ }

// Parse tool info from stdin
let toolName = '';
try {
  const input = fs.readFileSync(0, 'utf-8').trim();
  if (input) {
    const data = JSON.parse(input);
    toolName = data.tool_name || data.toolName || '';
  }
} catch (e) { /* no stdin or not JSON */ }

state.calls++;

// Track read-only streaks for analysis paralysis guard
const readTools = ['Read', 'Glob', 'Grep', 'WebFetch', 'WebSearch'];
if (readTools.includes(toolName)) {
  state.reads++;
} else if (toolName) {
  state.reads = 0;
}

// Save state
try {
  fs.mkdirSync(stateDir, { recursive: true });
  fs.writeFileSync(stateFile, JSON.stringify(state));
} catch (e) { /* ignore */ }

// Output warnings
const warnings = [];

if (state.reads >= 8) {
  warnings.push('ANALYSIS PARALYSIS: 8+ consecutive read-only operations without writing code. Either write code now or report what is blocking you.');
}

if (state.calls >= 200) {
  warnings.push('HIGH CONTEXT USAGE: Consider spawning subagents for remaining work to avoid context degradation.');
} else if (state.calls >= 150) {
  warnings.push('CONTEXT NOTE: Approaching high usage. Plan to delegate to subagents or wrap up current task soon.');
}

if (warnings.length > 0) {
  console.log(warnings.join('\n'));
}
