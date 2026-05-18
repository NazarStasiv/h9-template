---
description: Add Vitest and Playwright tests for new or changed code. Uses the test-writer skill. Use after every non-trivial implementation.
---

# /test — add tests for new or changed code

**Arguments:** $ARGUMENTS (file path, feature name, or blank to scan current diff)

Use the [test-writer skill](../skills/test-writer/SKILL.md) to add
tests.

Target resolution:

- If `$ARGUMENTS` names a file or module path: test that target.
- If `$ARGUMENTS` is "demo path" or "happy path": test the demo flow
  with a Playwright spec tagged `@demo`.
- If `$ARGUMENTS` is blank: run `git diff main...HEAD --name-only`,
  identify changed files, and add tests for any untested changes.

Follow the [test-writer skill](../skills/test-writer/SKILL.md). Write
tests, run them, and commit on the current branch.

After completion, print:

```
Tests added: <list of new test files>
Status: <all passing | N failing — see output above>
```

If tests are failing and the test-writer skill could not identify why,
escalate to the [bug-hunter skill](../skills/bug-hunter/SKILL.md) with
a one-line note.
