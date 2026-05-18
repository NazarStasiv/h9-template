---
description: Write a minimal failing test that reproduces a bug. Run it, confirm it fails, then hand off to the bug-hunter skill. Uses the reproduce-bug skill.
---

# /repro — write a failing repro test

**Arguments:** $ARGUMENTS (`<bug description, issue#, or stack trace>`)

Use the [reproduce-bug skill](../skills/reproduce-bug/SKILL.md) on
the bug below.

The skill will:
1. Read `ONBOARDING.md` to identify the test runner (run
   `/onboard .` first if it doesn't exist).
2. Resolve the bug source — issue number (`gh issue view`), stack
   trace, or free-form description.
3. Create a `repro/<slug>` branch.
4. Write a single minimal failing test in the project's existing test
   directory.
5. Run the test and confirm it fails (the verification trace per the
   [implementer skill](../skills/implementer/SKILL.md)).
6. Commit on the `repro/<slug>` branch with the failure trace in the
   commit body.

After the skill completes, print this exact handoff line to chat:

```
Repro on `repro/<slug>` — failing test in <path>. Now invoke the bug-hunter skill.
```

If the bug cannot be reproduced after two attempts, the skill will
return `INCOMPLETE`. In that case, do NOT commit; print the
investigation summary and let the user decide whether to:
- Re-read the bug source for missing context, or
- Switch to the bug-hunter skill with the original symptom (no repro), or
- Skip the bug and document it in `CHALLENGE.md` as "blocked: cannot
  reproduce".

Do not invoke the bug-hunter skill directly from this command — the
human decides whether to proceed based on the repro outcome.
