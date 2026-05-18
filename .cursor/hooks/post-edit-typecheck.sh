#!/usr/bin/env bash
# afterFileEdit hook. Runs typecheck and lint on the changed TypeScript file.
# Tolerant of missing package.json and missing scripts — Phase 1 of this
# template ships no Next.js skeleton, so this hook is a no-op until Phase 2.
#
# Hook contract (Cursor):
#   stdin:  JSON describing the edit, including a file path field
#   stdout: free-form text appended as additional context (or JSON for richer behavior)
#   exit code 0: success / advisory
#   exit code 2: blocking error (we never want this; failures are advisory)

set -uo pipefail

input="$(cat 2>/dev/null || true)"

# Best-effort extraction of the edited file path. Try multiple known fields
# so the same script works whether Cursor emits `file_path`, `path`, or a
# nested `tool_input.file_path` (matches Claude Code's format too).
file=""
if command -v jq >/dev/null 2>&1; then
  file="$(printf '%s' "$input" | jq -r '.file_path // .path // .tool_input.file_path // empty' 2>/dev/null || true)"
fi
if [ -z "$file" ]; then
  file="$(printf '%s' "$input" | grep -oE '"(file_path|path)"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"(file_path|path)"[[:space:]]*:[[:space:]]*"([^"]*)".*/\2/' || true)"
fi

case "$file" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

project_dir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

if [ ! -f "$project_dir/package.json" ]; then
  exit 0
fi

cd "$project_dir" || exit 0

pm=""
if [ -f "pnpm-lock.yaml" ] && command -v pnpm >/dev/null 2>&1; then
  pm="pnpm"
elif [ -f "package-lock.json" ] && command -v npm >/dev/null 2>&1; then
  pm="npm"
elif command -v pnpm >/dev/null 2>&1; then
  pm="pnpm"
elif command -v npm >/dev/null 2>&1; then
  pm="npm"
else
  exit 0
fi

has_script() {
  grep -q "\"$1\"[[:space:]]*:" package.json 2>/dev/null
}

if has_script "typecheck"; then
  if ! out="$("$pm" -s run typecheck 2>&1)"; then
    printf 'typecheck failed for %s:\n%s\n' "$file" "$(printf '%s' "$out" | tail -20)"
    exit 0
  fi
fi

if has_script "lint"; then
  if ! out="$("$pm" -s run lint --silent -- --max-warnings=999 2>&1)"; then
    printf 'lint failed for %s:\n%s\n' "$file" "$(printf '%s' "$out" | tail -10)"
    exit 0
  fi
fi

exit 0
