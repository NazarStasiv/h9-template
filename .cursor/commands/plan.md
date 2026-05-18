---
description: Update PLAN.md from the challenge brief or current progress. Uses the planner skill. Use at start of work and after each major merge.
---

# /plan — update PLAN.md

**Arguments:** $ARGUMENTS (a task description, challenge brief, or blank to refresh)

Use the [planner skill](../skills/planner/SKILL.md) to update `PLAN.md`.

If no arguments are given, treat this as a refresh: re-read `PLAN.md`,
check `gh pr list --state open`, move merged items to Done, and
re-prioritize Next.

Read [AGENTS.md](../../AGENTS.md) §1–§3 first to understand the team's
current Mission, stack, and role assignments. Then produce or update
`PLAN.md` per the format defined in the
[planner skill](../skills/planner/SKILL.md).

After updating, print a one-line summary to chat:

```
PLAN updated: N in flight, M queued, K done.
```

Do not open a PR for plan changes — `PLAN.md` is updated on the working
branch and committed alongside whatever task drove the update.
