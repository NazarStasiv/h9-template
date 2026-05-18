# MATRIX.md — tooling rationale

> This document explains **why** the team's AI workflow is configured the way
> it is. The audience is the hackathon judge (human and AI) who will inspect
> this repository to evaluate "how efficiently and optimally the workflow
> configuration is set up". The team operating manual is in
> [AGENTS.md](AGENTS.md); the day-of script is in [PLAYBOOK.md](PLAYBOOK.md).

---

## Thesis

The challenge theme is **Code less, AI more**. We optimized our setup so two
engineers (P1 and P2) work primarily through **Cursor's agent loop** with
shared file-based skills and slash commands, while one engineer (P3) runs
**Pi** for cross-provider routing — giving the team a built-in fallback if
the organizers' token quota lands on a non-default provider.

P1 and P2 each own three skills under [.cursor/skills/](.cursor/skills/);
P3 owns three more (`reviewer`, `test-writer`, `bug-hunter`) that exist
both in `.cursor/skills/` (mirrored for fallback) and in
[tools/pi/prompts/](tools/pi/prompts/) (the canonical Pi prompts). Slash
commands, hooks, MCP servers, and `AGENTS.md` are shared so anything one
engineer improves benefits the others immediately.

We considered (and explicitly rejected) two alternative configurations:

1. **One harness per engineer (3-way diversity, e.g. Claude Code +
   Cursor + Pi).** This gives a "breadth" narrative but no compounding.
   Skills written by one engineer don't translate cleanly to another's
   harness. The team pays a context-switching tax every time they
   pair-debug.
2. **Cursor for everyone (3 engineers).** Best compounding, but no
   provider fallback. If the organizers issue tokens for a provider
   Cursor can't accept, the entire team is blocked. Putting P3 on Pi
   gives a known-good escape valve.

---

## Configuration at a glance

| Surface          | Role                  | Primary artifacts                                                   | Investment |
| ---------------- | --------------------- | ------------------------------------------------------------------- | ---------- |
| **Cursor**       | primary (P1, P2)      | [.cursor/](.cursor/) — 19 skills, 10 commands, 4 rules, hooks, MCP  | ~75%       |
| **Pi**           | co-primary (P3)       | [tools/pi/](tools/pi/) — 3 prompts, 1 skill, system-prompt append   | ~15%       |
| Cross-cutting    | shared SSoT           | [AGENTS.md](AGENTS.md), [PLAYBOOK.md](PLAYBOOK.md)                  | ~10%       |

---

## Why Cursor for two engineers

1. **Skills as files.** Each skill under [.cursor/skills/](.cursor/skills/)
   is a markdown file with explicit ownership. This makes the team's
   division of labor a property of the repository, not a property of any
   individual's editor configuration. A judge can read the SKILL.md files
   directly and see who owns what.

2. **Slash commands are shared.** When P1 improves the `/ship` command
   in [.cursor/commands/ship.md](.cursor/commands/ship.md), P2 picks
   that up the next time they invoke it. There is no syncing; the repo
   is the sync.

3. **Hooks enforce discipline uniformly.** The
   [post-edit-typecheck hook](.cursor/hooks/post-edit-typecheck.sh) fires
   for both Cursor engineers on every TypeScript file save. The team's
   quality bar is encoded in one place.

4. **MCP servers at project scope.** [.cursor/mcp.json](.cursor/mcp.json)
   declares Playwright (for demo recording) and Context7 (for current
   library docs). Both engineers get them on first session approval.

5. **Cursor Agent Mode for orchestration.** Cursor's Agent mode reads
   skills on demand, so calling out a persona ("act as the reviewer"
   or "/review") triggers the corresponding SKILL.md without
   per-session setup.

---

## Why Pi for the third engineer (P3)

Pi covers QA — reviewing, testing, bug-hunting — and brings two
hackathon-critical capabilities:

1. **Cross-provider routing.** Pi supports 15+ providers natively.
   Mid-session model switching via `/model` or `Ctrl+L`. If the
   organizers issue tokens for OpenAI, Groq, Bedrock, or a local
   model, Pi accepts them without changing the prompts.

2. **Tree-structured session history.** `/tree` for forking
   exploratory work — useful for the bug-hunter persona, which often
   needs to back up and try a different hypothesis.

We deliberately scoped Pi to **read-only / safest** flows
(`/review`, `/test`, `/bug-hunt`). Pi explicitly skips file-based
subagents and project-scoped MCP, so we keep the more sensitive
operations (planning, implementation, UI design) on Cursor where
the orchestration surface is richer.

The Pi prompts live at [tools/pi/prompts/](tools/pi/prompts/) and
the Pi-specific system prompt append at
[tools/pi/APPEND_SYSTEM.md](tools/pi/APPEND_SYSTEM.md). The
[reviewer](.cursor/skills/reviewer/SKILL.md),
[test-writer](.cursor/skills/test-writer/SKILL.md), and
[bug-hunter](.cursor/skills/bug-hunter/SKILL.md) skills mirror these
so P1 or P2 can take over from Cursor if P3 is blocked.

---

## Token routing assumptions and fallbacks

The hackathon organizers will issue licensed token quotas. We do not know
in advance which provider. Our setup degrades gracefully across the
plausible scenarios:

| Provider scenario          | Cursor (P1, P2)             | Pi (P3)                              | Action |
| -------------------------- | --------------------------- | ------------------------------------ | ------ |
| Anthropic API              | works (default model)       | works                                | none — design center |
| OpenAI / Bedrock / Vertex  | switch model in Cursor      | works (multi-provider)               | P3 confirms working flows from Pi first |
| Mixed gateway / OpenRouter | configure in Cursor settings | works (`pi install -l ./tools/pi`)  | ~5 min setup |

In all scenarios, the [AGENTS.md](AGENTS.md) operating manual is
unchanged. The team's workflow contract — branching, PRs, DoD — is the
same regardless of which surface the engineer is using.

---

## What "optimally configured workflow" looks like, concretely

We took the judging criterion seriously. The configuration in this
repository is designed to demonstrate:

- **Explicit ownership.** Every skill names a single owner. A judge can
  identify who is responsible for each capability without asking.
- **Separation of concerns.** Skill system prompts are tightly scoped;
  failure modes documented in [PLAYBOOK.md](PLAYBOOK.md) "Recovery
  patterns".
- **Security by design.** The team avoids committing secrets via
  `.gitignore`, denies `curl` / `wget` patterns in shell commands by
  team convention, and routes any "run this dangerous command"
  decision through a human ack in chat.
- **Reproducibility.** The setup is a repository. Anyone can clone it
  and recreate the team's workflow exactly. No personal
  `~/.cursor/` state is required for the configured behavior.
- **Graceful degradation.** Cursor + Pi covers two providers natively.
  If both go down, the team can still commit and PR via plain `git`
  and `gh` while AI returns.
- **Cross-tool standards.** [AGENTS.md](AGENTS.md) follows the open
  AGENTS.md specification, which both Cursor and Pi read. We did not
  invent a private convention.

---

## What we deliberately did **not** do

For honesty: here are configuration choices we considered and rejected.

- **No Claude Code on the team.** Anthropic's terminal CLI is excellent
  but requires every engineer to install and configure a third surface.
  For a 4-hour event with three engineers, two surfaces is the sweet
  spot — anything more dilutes the compounding effect of shared skills.
- **No CI workflows yet.** Phase 1 of this template is configuration
  only. CI is added in Phase 2 with the Next.js skeleton, when there is
  real code to lint and test.
- **No Cursor Cloud Agents.** This would require the team to have
  Cursor's Background Agents available on event day, which depends on
  the licensed token plan the organizers issue. We do not want a
  hard dependency. The local `scripts/spike.sh` covers the same need.
- **No "best of N" attempt orchestration.** Tempting, but it eats tokens
  fast. The team has 5 hours, not unlimited budget.
- **No agent-written `AGENTS.md`.** Published research showed auto-
  generated `AGENTS.md` files underperform human-written ones by a
  measurable margin. This file and AGENTS.md were written by humans,
  and will be tuned by humans during the prep week.
