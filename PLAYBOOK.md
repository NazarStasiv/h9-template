# PLAYBOOK.md — hackathon day timeline

This is the minute-level script for the three engineers. Print it, keep
it on a second monitor, or pin a chat panel to it. Times are wall-clock
elapsed from the start of the building window.

The plan is built around five phases. Each phase has explicit deliverables
and a stop-condition: if a phase's deliverable is not done by its end time,
the team rolls forward anyway. The 4-hour cap is sacred; the demo is what
gets judged.

---

## Pre-event checklist (the morning of)

Done by 30 minutes before kickoff:

- [ ] **Cursor** installed and logged in on all three laptops (P1 and P2
      will use it as primary; P3 keeps it installed as a fallback).
- [ ] **Pi** installed and logged in on P3's laptop:
      `npm install -g @earendil-works/pi-coding-agent` (or per
      [https://pi.dev/docs/latest](https://pi.dev/docs/latest)).
- [ ] `gh auth status` returns `Logged in to github.com`.
- [ ] `git --version` prints a version.
- [ ] `npx playwright install chromium` has been run at least once
      (browsers cached locally) — needed for demo recording.
- [ ] Each engineer has cloned a fresh copy of this template into a new
      empty directory; the team agrees in advance which laptop is the
      "main" laptop that owns `main` branch pushes (default: P1).
- [ ] The team's GitHub repo for the hackathon exists (create empty repo,
      add it as `origin` on P1's laptop).
- [ ] Provider tokens (Anthropic / OpenAI / whatever the organizers issue)
      are set in each engineer's shell. P3 confirms Pi can route to the
      provider via `/model` before kickoff.
- [ ] MCP servers in [.cursor/mcp.json](.cursor/mcp.json) (Playwright and
      Context7) approved on first use by P1 and P2.

---

## Phase 1 — Brief & Plan (0:00–0:20)

**Goal:** turn the challenge brief into a one-page `MISSION.md` and a
priority-ordered `PLAN.md`. Nothing else.

### Fork on challenge type (decide in the first 60 seconds)

The first thing P1 does after reading the brief is decide which kind
of challenge this is. The rest of Phase 1 branches on this:

- **Build from spec** (we own the codebase, build a feature): use
  [MISSION.md](MISSION.md) as canonical, ignore
  [CHALLENGE.md](CHALLENGE.md), continue with `/plan` per the per-role
  steps below. This is the default path.
- **Fix problems in 1–6 given repos:** fill out
  [CHALLENGE.md](CHALLENGE.md) instead of MISSION.md. Then for each
  given repo, run `/onboard <path>` (in parallel via worktrees if you
  have 3+ repos). For each problem sourced from a GitHub issue,
  invoke the [issue-triage skill](.cursor/skills/issue-triage/SKILL.md)
  with the issue number. THEN run `/plan` against the consolidated
  picture in CHALLENGE.md.
- **Hybrid** (one repo to extend + side tasks): both files apply.
  CHALLENGE.md tracks the side tasks; MISSION.md captures the headline
  goal.

The Phase 1 stop condition (below) accepts whichever document(s) the
fork required.

### P1 — Planner / Architect / Demo (Cursor)

1. Read the challenge brief end to end without taking notes.
2. Open Cursor at the repo root. Use Agent mode.
3. Run `/plan "<paste the challenge brief verbatim>"`. The
   [planner skill](.cursor/skills/planner/SKILL.md) produces a draft
   `PLAN.md`.
4. Manually rewrite the four bullets in [AGENTS.md §1](AGENTS.md). Commit
   `MISSION.md`, `AGENTS.md` update, and the draft `PLAN.md` on `main`.
   This is the only direct push to `main` allowed all day.
5. Push to GitHub. Announce on team chat: "MISSION up, start your spikes."

### P2 — Implementer (Cursor)

1. Read the brief.
2. Wait for P1's announcement (do not start coding).
3. Once `MISSION.md` is up, pull, read `PLAN.md`, and pick the highest-
   priority item in your column.
4. Run `/spike <name> "<one-line objective>"` to open a worktree for the
   first feature. Open the worktree in a new Cursor window:
   `cursor ../hack9-<name>`.

### P3 — Reviewer / Tester (Pi)

1. Read the brief.
2. While waiting on P1, run `npx playwright install chromium` if not done.
3. Launch Pi at the repo root. Confirm the Pi pack is installed:
   `bash scripts/pi-install.sh`. Verify `/review`, `/test`, and
   `/bug-hunt` are available.
4. When `PLAN.md` lands, read it and identify the riskiest module — that's
   where your first tests go.

**Stop condition at 0:20:** `PLAN.md` plus the brief-document
appropriate to the fork (`MISSION.md`, `CHALLENGE.md`, or both for
hybrid) are committed to `main`. If the fork was "given repos," each
repo also has an `ONBOARDING.md` from `/onboard`. If not, P1 announces
a 10-minute extension. No further extensions allowed.

---

## Phase 2 — Build (0:20–3:00)

**Goal:** ship the happy path of the demo win condition. Quality goes in
during Phase 3.

### Pattern of the day: Writer/Reviewer with fresh context

This phase runs an explicit **Writer/Reviewer split** — the highest-
leverage quality pattern in modern AI-coding best practices. We make it
explicit in our setup:

- **P2 is the Writer** (Cursor). P2 holds the implementation context, runs
  the [implementer skill](.cursor/skills/implementer/SKILL.md), opens PRs.
- **P3 is the Reviewer with fresh context** (Pi). P3 reads each PR in a
  separate Pi session (no prior implementation context), runs
  `/review`, and emits `OK_TO_MERGE: yes/no`. A second pair of
  eyes that wasn't biased by the act of writing the code.
- **P1 merges** (Cursor). Only P1 merges, and only after P3's `OK_TO_MERGE:
  yes` is the most recent reviewer comment. P1 may run
  `/pr-checklist <num>` as a cheap deterministic gate before merging.

This is the same pattern as a small-team code-review culture, but
codified into the harnesses — explicit skill personas, explicit slash
commands, explicit verdict format. Easy to pitch.

### P1 — Planner / Architect / Demo (Cursor)

- Watch the PR queue. Review and merge anything from P2 or P3 that has an
  `OK_TO_MERGE: yes` on it.
- Every 30 minutes, update `PLAN.md` with current status: what's merged,
  what's in flight, what's deferred to `TODO.md`.
- If P2 or P3 are blocked, spawn a `/spike` of your own to unblock them.
- At 2:00 mark, do a "soft demo rehearsal" inside `main` for yourself.
  Identify the three things most likely to break and warn the team.

### P2 — Implementer (Cursor)

- Use `/ship <feature>` for clearly-scoped features. This guides Cursor
  through planner → implementer → test-writer → reviewer → `gh pr create`
  sequentially in your session.
- For exploratory features, use `/spike` first, then promote the spike
  branch to a `feat/` PR once viable.
- Never have more than one un-merged PR open from your laptop at a time.
  If a review is taking longer than 10 minutes, ping P1 and switch to
  the next task in a worktree.

### P3 — Reviewer / Tester (Pi)

- React to every PR within 5 minutes: run `/review <PR#>` in Pi, post the
  reviewer report as a PR comment, mark `OK_TO_MERGE: yes` or `no`.
- Between reviews, run `/test` on the highest-risk module identified in
  Phase 1.
- At 2:30, run `/bug-hunt` against the staged-but-unmerged code.
  Surface anything that would embarrass the team in the demo.

**Stop condition at 3:00:** the demo win condition runs end-to-end on
`main` in `pnpm dev`. If it doesn't, declare it now, scope it down, and
update `MISSION.md` accordingly.

---

## Phase 3 — Polish (3:00–3:45)

**Goal:** make the happy path look intentional. No new features.

### P1 — Planner / Architect / Demo (Cursor)

- Apply the `100-demo-polish` rule from
  [.cursor/rules/100-demo-polish.mdc](.cursor/rules/100-demo-polish.mdc):
  audit happy-path interactions for missing loading/empty/error states.
- Run `/demo-record` to capture the first take of the Playwright video.

### P2 — Implementer (Cursor)

- Address only blocking bugs P3 surfaces in this phase. Anything
  cosmetic goes to `TODO.md`, not into a PR.
- If asked to leave the code alone, do so. Stand by for demo-recording
  assistance.

### P3 — Reviewer / Tester (Pi)

- Run a final pass with `/bug-hunt` on the full `main` branch.
- Verify the happy path on a clean clone (use `git worktree add ../verify`
  and run from there) to make sure the demo isn't relying on local-only
  state.

**Stop condition at 3:45:** Playwright recording has at least one
complete take of the happy path. If not, switch to live screen recording
as a fallback (announce in chat).

---

## Phase 4 — Demo prep (3:45–4:30)

**Goal:** ship the demo artifact. Slides, video, README — in that order
of importance.

### P1 — Planner / Architect / Demo (Cursor)

- Run `/demo` to follow the
  [demo-builder skill](.cursor/skills/demo-builder/SKILL.md). It writes
  a `DEMO.md` with the narration, embeds the recording link, and
  produces a 3-slide pitch outline in `DEMO_SLIDES.md`.
- Rehearse the narration aloud once. Time it. Aim for < 3 minutes.

### P2 — Implementer (Cursor)

- Update repo `README.md` with: one-paragraph description, screenshot,
  how to run locally, what's in the demo video.
- Stand by to fix any tiny copy issue P1 surfaces during rehearsal.

### P3 — Reviewer / Tester (Pi)

- Open the demo video in a clean browser. Verify audio and resolution.
- Verify `README.md` instructions work on the clean worktree.
- Be ready to swap to a second-take recording if needed.

**Stop condition at 4:30:** `DEMO.md`, `DEMO_SLIDES.md`, README, and the
video are all committed and pushed to `main`.

---

## Phase 5 — Buffer & submit (4:30–5:00)

**Goal:** submission survives all reasonable adversarial conditions.

- Verify `main` is green: clone fresh, `pnpm install`, `pnpm dev`, walk
  the happy path manually. If anything is broken, revert the offending
  commit; do not try to fix.
- Push final tag `v1.0-demo` to lock the submitted state.
- Submit per organizers' instructions. Save submission confirmation.
- Stand down. Watch other teams. Be gracious.

---

## Recovery patterns

### "Cursor model is rate-limited or returning errors"

1. Affected engineer (P1 or P2) switches model in Cursor settings
   (Cursor supports multiple providers).
2. If no model works in Cursor, ask P3 to handle the current task in Pi
   using the corresponding `/review`, `/test`, or `/bug-hunt` prompt.
3. Announce in team chat: "P2 handing off to P3 via Pi for 15 minutes."
4. Switch back to Cursor when the rate limit clears (typically <15 min).

### "Pi model is unavailable"

1. P3 switches provider via `/model` in Pi (15+ providers supported).
2. If no provider works, P3 switches to Cursor and runs the
   [reviewer](.cursor/skills/reviewer/SKILL.md),
   [test-writer](.cursor/skills/test-writer/SKILL.md), and
   [bug-hunter](.cursor/skills/bug-hunter/SKILL.md) skills there.
3. The skills mirror the Pi prompts, so behavior should be identical.
4. Announce in chat: "P3 on Cursor temporarily."

### "GitHub is down"

1. Continue committing locally. Replace `gh pr create` with branch
   pushes to a local bare-repo clone (`git clone --bare main.git
   ../sync.git`) that the team uses as a temporary `origin`.
2. Push to GitHub when it recovers, before submission.

### "P1 gets pulled into a meeting / leaves the room"

1. P2 becomes acting P1 for the duration. Acting P1 has merge authority
   for that period only. Note the handoff in PR comments
   (`@<actual-p1>` ack required when they're back).

---

## Closing reminders

- The hackathon judges look at the **repo** at least as much as the
  **demo**. `AGENTS.md`, `MATRIX.md`, `.cursor/skills/*`, and PR bodies
  are all judge-visible artifacts. Treat them like product surface.
- The 4-hour cap is sacred. We do not chase perfection past 3:00.
- We win by orchestrating AI, not by writing more code than the next
  team. If you find yourself typing code instead of typing prompts,
  pause and ask why.
