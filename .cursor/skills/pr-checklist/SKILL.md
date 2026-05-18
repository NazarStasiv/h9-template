---
name: pr-checklist
description: Produce a Definition-of-Done checklist for an open PR against AGENTS.md §5. Cheap deterministic gate used before /pr-merge. Use only when explicitly invoked with /pr-checklist <PR#>.
---

# PR Definition-of-Done checklist

Cheap deterministic gate used before merging a PR. Pulls live PR data
via `gh`, then checks each item from
[AGENTS.md §5](../../../AGENTS.md) and emits a verdict. Complements
the broader [reviewer skill](../reviewer/SKILL.md) — `/pr-checklist`
answers "is this mergeable per the rules" while the reviewer skill
answers "is this any good".

## Usage

```text
/pr-checklist 42
```

## Fetch the live PR data

Before producing the checklist, fetch these via `gh`:

- Title and body: `gh pr view $ARGUMENTS --json title,body,reviewDecision,mergeable,baseRefName,headRefName`
- Diff (name-only): `gh pr diff $ARGUMENTS --name-only`
- Checks: `gh pr checks $ARGUMENTS`
- Recent reviewer comments: `gh pr comments --limit 5 $ARGUMENTS`

## Your task

Read the fetched PR data above. Then produce the checklist below,
marking each item:

- `[x]` if the PR clearly satisfies the criterion
- `[ ]` if the PR clearly does not
- `[?]` if uncertain; cite the evidence in one line

### Checklist (from AGENTS.md §5)

```markdown
## PR-checklist for #$ARGUMENTS

**Title:** <pull from PR data>
**Branch:** <head> -> <base>
**Reviewer decision:** <reviewDecision>
**Mergeable:** <mergeable>

### Definition of Done
- [ ] Typecheck clean (or absent in Phase 1 — advisory)
- [ ] Tests pass for changed modules
- [ ] Screenshot attached for UI changes (check `gh pr view` for image markdown)
- [ ] Reviewer comment with `OK_TO_MERGE: yes` is the most recent reviewer comment
- [ ] No new files under `.env`, `secrets/`, `id_rsa*`, or `.pem`
- [ ] One-sentence "what + why" at the top of the PR body
- [ ] PR title follows Conventional Commits (`feat(scope): …`)

### Risks
- <list anything from the diff name-only that touches sensitive paths:
  AGENTS.md, .cursor/, .env*, secrets/, .github/>

### Verdict
OK_TO_MERGE: yes | no | needs human verification
```

## Rules

1. **Read-only.** Do not edit any files. Do not post the checklist
   to the PR; return it inline to the user.
2. **Cite evidence.** Every `[?]` must include why you can't tell.
3. **Be strict on secrets.** Any file under the denied paths fails
   the secrets check, no exceptions.
4. **Be strict on the reviewer comment.** The most-recent comment
   from any user containing `OK_TO_MERGE: yes` counts; older
   approvals are stale if a newer comment exists.
5. **Output the verdict on its own final line** so `/pr-merge` and
   `gh pr comment` consumers can grep it deterministically.

## Don't

- Don't try to merge from this skill. Merging is owned by
  [/pr-merge](../../commands/pr-merge.md) (P1-only).
- Don't post the checklist as a PR comment automatically. The user
  decides whether to forward it.
- Don't read the full diff (`gh pr diff` without `--name-only`) —
  too much context for a deterministic gate. Trust the name-only
  list plus the reviewer comment.
