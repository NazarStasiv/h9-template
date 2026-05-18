# h9 template

Configuration scaffold for a 3-engineer hackathon team running on
**Cursor** (two engineers) and **Pi** (one engineer). Cursor handles
the planning and implementation flow with file-based skills; Pi
handles QA (review, test, bug-hunt) with cross-provider model routing
as a built-in hedge.

This is **Phase 1**: configuration only. There is no application
skeleton yet — that lands in Phase 2 after the team's prep dry-run
finalizes the stack choices.

## 60-second bootstrap

```bash
# 1. Verify prerequisites
cursor --version          # Cursor IDE (P1 and P2)
pi --version              # Pi CLI agent (P3 only)
gh auth status            # GitHub CLI logged in
git --version             # any reasonably recent git
node --version            # Node 20+ for MCP servers via npx

# 2. Optional: pre-pull MCP servers so first invocation is instant
npx -y @playwright/mcp@latest --version

# 3. Open Cursor at the repo root (P1 and P2)
cursor .
```

Cursor's skills, slash commands, hooks, and MCP servers auto-load from
the `.cursor/` directory on first open. MCP servers declared in
[.cursor/mcp.json](.cursor/mcp.json) prompt for one-time approval the
first time they're used.

For the Pi engineer (P3):

```bash
# Install the Pi pack and launch Pi at the repo root
bash scripts/pi-install.sh
```

## Read these in order

For the team — before hackathon day:

1. [AGENTS.md](AGENTS.md) — the operating manual all three engineers
   and both AI harnesses read.
2. [PLAYBOOK.md](PLAYBOOK.md) — minute-by-minute day-of script.
3. [MATRIX.md](MATRIX.md) — why this configuration exists (also written
   for the hackathon judges).

For an AI judge inspecting the repo:

1. [AGENTS.md](AGENTS.md) and [MATRIX.md](MATRIX.md) explain intent.
2. [.cursor/skills/](.cursor/skills/) and
   [.cursor/commands/](.cursor/commands/) show the Cursor orchestration
   surface.
3. [tools/pi/](tools/pi/) shows the Pi prompts and skill that mirror
   the read-only Cursor flows.

## Repo map

```text
.
├── AGENTS.md                       # operating manual (SSoT for all surfaces)
├── PLAYBOOK.md                     # day-of minute timeline x 3 roles
├── MATRIX.md                       # tooling rationale for judges
├── CHALLENGE.md                    # template for given-repo challenges
├── .gitignore
│
├── .cursor/                        # PRIMARY: Cursor config (P1, P2)
│   ├── mcp.json                    # MCP servers (Playwright, Context7)
│   ├── hooks.json                  # session-start + post-edit hooks
│   ├── hooks/                      # hook scripts
│   ├── rules/                      # 4 .mdc rules (core, TS, shadcn, demo)
│   ├── commands/                   # 10 slash commands (plan, spike, ship, …)
│   └── skills/                     # 19 skills — 9 personas + 10 procedural
│
├── tools/pi/                       # PRIMARY: Pi pack for P3 (QA)
│   ├── package.json                # Pi pack manifest
│   ├── APPEND_SYSTEM.md            # adds to Pi system prompt
│   ├── prompts/                    # /review, /test, /bug-hunt for Pi
│   └── skills/playwright-e2e/      # Playwright E2E skill
│
└── scripts/
    ├── spike.sh                    # git worktree + new Cursor window
    └── pi-install.sh               # install the Pi pack and launch Pi
```

## Phase 2 — what's next

After the team's prep-week dry-run (planned for ~5 days before the event),
Phase 2 adds:

- Next.js 15 App Router skeleton with shadcn/ui, Tailwind, Drizzle+libSQL.
- `package.json` with `typecheck`, `lint`, `test`, `dev` scripts.
- `.github/workflows/ci.yml` for type/lint/test on push.
- A `DEMO.md` template that the demo-builder skill fills in on event day.

## License

This template is intentionally unlicensed in Phase 1. The team will pick a
license alongside the application skeleton in Phase 2.
