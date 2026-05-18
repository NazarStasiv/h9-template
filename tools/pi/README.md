# hack9-pi — Pi pack for P3

This is the **primary Pi pack** for the team's QA engineer (P3). Pi was
chosen for the third role because it supports 15+ providers natively,
giving the team a cross-provider hedge against whatever token quota the
organizers issue on event day (see [/MATRIX.md](../../MATRIX.md)).

The two Cursor engineers (P1, P2) handle planning and implementation;
P3 handles the read-only QA flows (review, test, bug-hunt) from Pi.

## Installation

From the repository root:

```bash
bash scripts/pi-install.sh
```

This installs the pack into the project's `.pi/settings.json` (local
path install, no files copied) and launches Pi. Equivalent manual flow:

```bash
pi install -l ./tools/pi
pi
```

Prerequisite: install the Pi CLI globally if not present.

```bash
npm install -g @earendil-works/pi-coding-agent
# or see https://pi.dev/docs/latest for current install instructions
```

## What's in the pack

```text
tools/pi/
├── package.json          # Pi pack manifest
├── README.md             # this file
├── APPEND_SYSTEM.md      # additions to Pi's system prompt
├── prompts/              # three slash commands
│   ├── review.md         # /review — read-only PR/diff review
│   ├── test.md           # /test — add Vitest + Playwright tests
│   └── bug-hunt.md       # /bug-hunt — investigate, produce hypotheses
└── skills/
    └── playwright-e2e/   # on-demand Playwright skill
        └── SKILL.md
```

The three prompts mirror the corresponding Cursor skills exactly so
behavior is consistent across the team's two harnesses.

## Provider selection

Pi reads `~/.pi/agent/models.json` for custom providers. P3 should
configure providers before the event per the issued token type. Switch
providers mid-session via `/model` or `Ctrl+L`.

## Cross-tool coordination

- **Cursor engineers (P1, P2)** can run the mirrored skills directly
  from Cursor when P3 is unavailable. See
  [.cursor/skills/reviewer/SKILL.md](../../.cursor/skills/reviewer/SKILL.md),
  [.cursor/skills/test-writer/SKILL.md](../../.cursor/skills/test-writer/SKILL.md),
  [.cursor/skills/bug-hunter/SKILL.md](../../.cursor/skills/bug-hunter/SKILL.md).
- **P3** can fall back to Cursor too if Pi is down on all configured
  providers — same skills, same behavior.

## Don't

- Don't commit anything Pi writes outside `tools/pi/` or the test
  directories. PRs are owned by Cursor engineers.
- Don't run `/review` or `/test` from Pi against PRs that a Cursor
  user has already produced reports for — duplicates confuse the team.
- Don't forget to announce your surface in team chat (per
  [AGENTS.md §6](../../AGENTS.md)).
