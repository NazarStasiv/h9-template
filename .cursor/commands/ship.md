---
description: Full plan-implement-test-review-PR cycle for a single small feature. Use for features estimated <= 30 minutes.
---

# /ship — full ship cycle for a small feature

**Arguments:** $ARGUMENTS (`<feature description, one sentence>`)

Execute the full ship cycle for one small feature.

Run these five steps in order. Pause for a one-word user confirmation
between steps 2 and 3, and between steps 4 and 5. The user types
"continue" to proceed, "stop" to abort, or "fix: <…>" to redirect.

### Step 1 — Plan

Use the [planner skill](../skills/planner/SKILL.md): add this feature
to `PLAN.md` as a "Now" entry with the current branch as the destination.
If the current branch is `main`, create `feat/<slug>` first.

### Step 2 — Confirmation gate (user types continue/stop/fix)

Print the planned change summary and ask:

```
Plan ready. Continue with implementation? (continue / stop / fix: <…>)
```

### Step 3 — Implement

Follow the [implementer skill](../skills/implementer/SKILL.md) with
the planned feature. Edit, run typecheck, and commit. Do **not** open
a PR yet.

### Step 4 — Test

Follow the [test-writer skill](../skills/test-writer/SKILL.md) to add
tests for the change. Commit on the same branch.

### Step 5 — Confirmation gate (user types continue/stop/fix)

Follow the [reviewer skill](../skills/reviewer/SKILL.md) on the
staged work (no PR yet). Print the report.

If the report is `OK_TO_MERGE: no`, stop here and ask the user:

```
Reviewer found issues. continue (open PR anyway) / stop / fix: <…>
```

If `OK_TO_MERGE: yes`, ask:

```
Review clean. Open PR? (continue / stop)
```

### Step 6 — Open PR

Run `gh pr create` with:

- Title: derived from the feature description
- Body: includes the one-sentence feature description, the
  reviewer report, and the Definition of Done checklist from
  [AGENTS.md §5](../../AGENTS.md).

Print the PR URL.

## Notes

For the Cursor user, this command guides the AI through a sequence
of skill applications. The AI invokes each skill in turn and confirms
with you between phases.
