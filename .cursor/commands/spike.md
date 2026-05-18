---
description: Create a parallel attempt in a git worktree. Use when exploring a risky direction without blocking main work, or to enable two engineers to work on different features simultaneously without merge conflicts.
---

# /spike — create a parallel worktree

**Arguments:** $ARGUMENTS (`<spike-name> <one-line-objective>`)

Create a git worktree for a parallel attempt.

Steps:

1. Parse the first argument as the spike name (must be a short
   kebab-case slug). Reject names containing slashes, spaces, or
   starting with a digit. The rest of `$ARGUMENTS` is the objective.
2. Verify the worktree doesn't already exist:
   `git worktree list | grep -q "hack9-<name>"` — if it does, stop and
   print "worktree already exists" with the path.
3. Create the worktree:
   ```bash
   git worktree add "../hack9-<name>" -b "spike/<name>"
   ```
   Or use the helper script:
   ```bash
   bash scripts/spike.sh <name> "<objective>"
   ```
4. Write `../hack9-<name>/SPIKE.md` with this content:

   ```markdown
   # Spike — <name>

   **Created:** <ISO timestamp>
   **Owner:** <ask the user which engineer owns this spike>
   **Objective:** <the rest of $ARGUMENTS after the name>

   ## What we're trying to learn
   <expand objective into 2–3 sentences>

   ## Time box
   <default: 45 minutes. Stop and write findings if exceeded.>

   ## Findings (fill in as you go)
   - …

   ## Decision
   <after the time box: promote to feat/ branch, or discard with notes>
   ```

5. Print the next-step instructions:

   ```
   Spike ready at ../hack9-<name>.

   Open in a new Cursor window:
     cursor ../hack9-<name>

   Or attach manually:
     cd ../hack9-<name>
   ```

Do **not** open the new Cursor window yourself — the user does that.
Do not commit anything in the new worktree from the current session.
