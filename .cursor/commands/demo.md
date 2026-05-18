---
description: Produce the demo artifact — DEMO.md narration, Playwright recording, DEMO_SLIDES.md pitch. Uses the demo-builder skill. Use only in Phase 4 (3:45+).
---

# /demo — produce the demo artifact

**Arguments:** $ARGUMENTS (blank for full demo, or `rerecord <section>`, or `polish narration`)

Use the [demo-builder skill](../skills/demo-builder/SKILL.md) to
produce the demo artifact.

Pre-flight checks before delegating:

1. Verify it is Phase 4 (elapsed time ≥ 3:45). If unsure, ask the user
   to confirm we are out of Phase 2 (build) and Phase 3 (polish). The
   feature freeze must be in effect. If not, refuse and tell the user
   to run `/demo` later.
2. Verify `MISSION.md` exists and the happy path works (`pnpm dev`
   then walk it manually). If broken, refuse and route to the
   [bug-hunter skill](../skills/bug-hunter/SKILL.md).
3. Verify Playwright is installed: `npx playwright --version` succeeds.
   If not, run `npx playwright install chromium`.

Then follow the [demo-builder skill](../skills/demo-builder/SKILL.md)
with the arguments. Produce:

- `DEMO.md` — narration script
- `DEMO_SLIDES.md` — three-slide pitch
- `demo.webm` — Playwright recording at repo root
- `docs/screenshots/*.png` — key moments

Commit all artifacts on the current branch with message:

```
docs(demo): add demo recording, narration, and slides
```

Print the final checklist:

```
Demo ready. Verify before submission:
[ ] demo.webm plays with audio
[ ] DEMO.md narration matches recording
[ ] DEMO_SLIDES.md references MATRIX.md
[ ] README.md links to demo.webm
[ ] Happy path passes on a clean clone
```
