---
description: Implement a clearly-scoped feature from PLAN.md. Uses the implementer skill, which opens a PR when done.
---

# /implement — implement a feature from PLAN.md

**Arguments:** $ARGUMENTS (`<feature title from PLAN.md>`)

Use the [implementer skill](../skills/implementer/SKILL.md) to
implement the named feature.

Before delegating:

1. Verify `PLAN.md` exists at the repo root. If not, stop and tell the
   user to run `/plan` first.
2. Verify the feature title in `$ARGUMENTS` matches an entry in
   `PLAN.md` "Now" or "Next". If no match, stop and ask which entry
   they meant.
3. Verify the current branch matches the conventions in
   [AGENTS.md §4.1](../../AGENTS.md). If on `main`, run
   `git switch -c feat/$(echo "$ARGUMENTS" | tr ' ' '-' | tr -cd '[:alnum:]-' | tr '[:upper:]' '[:lower:]' | head -c 40)`
   first.

Then follow the [implementer skill](../skills/implementer/SKILL.md)
with the feature description and the current branch name. Implement,
run typecheck, commit, and open a PR.

When done, print the PR URL and a one-line status:

```
PR opened: <url>
Status: awaiting reviewer
```
