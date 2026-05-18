#!/usr/bin/env bash
# scripts/pi-install.sh — install the Pi pack and launch Pi.
#
# Run this on P3's laptop before the event (and any time the Pi pack is
# updated). Pi is P3's primary surface, not a fallback — see MATRIX.md.

set -euo pipefail

# --- preconditions -------------------------------------------------------

if ! git_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  echo >&2 "error: not inside a git repository"
  exit 66
fi
cd "$git_root"

if [ ! -d "tools/pi" ]; then
  echo >&2 "error: tools/pi/ not found at $git_root"
  exit 67
fi

if ! command -v pi >/dev/null 2>&1; then
  echo >&2 "error: 'pi' CLI not found in PATH"
  echo >&2 "install with: npm install -g @earendil-works/pi-coding-agent"
  echo >&2 "or see https://pi.dev/docs/latest for current install instructions"
  exit 127
fi

# --- announce ------------------------------------------------------------

cat <<'EOF'
╭─────────────────────────────────────────────────────────────────────╮
│ Pi install                                                           │
│                                                                      │
│ Installing the hack9 Pi pack into this project's .pi/settings.json.  │
│ Pi is P3's primary surface — see MATRIX.md for the rationale.        │
╰─────────────────────────────────────────────────────────────────────╯
EOF

# --- install the local pack ----------------------------------------------
#
# 'pi install -l <path>' writes to project-scoped .pi/settings.json
# and adds the local path to the package list. No files copied.

echo "Installing tools/pi/ into .pi/settings.json (local path install)…"
pi install -l ./tools/pi

# --- launch Pi -----------------------------------------------------------

cat <<'EOF'

Pi pack installed. Launching Pi…

Available prompts:
  /review      — read-only PR/diff review
  /test        — add Vitest + Playwright tests
  /bug-hunt    — investigate a symptom, produce hypotheses

For anything outside QA (planning, implementation, UI design), defer
to P1 / P2 on Cursor. See AGENTS.md §3 for the role split and
tools/pi/APPEND_SYSTEM.md for the operating mode.
EOF

exec pi
