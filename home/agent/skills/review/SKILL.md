---
name: review
description: Use for a read-only critique of code changes against my STYLE.md — correctness, security, design and tests — reported as Conventional Comments.
context: fork
---

Review the changes in scope (below) for:

- violations of `STYLE.md` (already in your context)
- correctness bugs, edge cases, and error handling
- security issues (injection, unsafe input, leaked secrets)
- design & fit: does the change belong here, integrate cleanly, sit at the right abstraction
- tests: appropriate coverage, and would they actually fail if the behaviour broke

The review is done when every changed hunk has been read and checked against each item above.

## What to review

Determine the scope from the argument:

- **An MR/PR reference** (URL, `!123`, `#123`): fetch its diff — GitLab via `glab mr diff <id>`,
  GitHub via `gh pr diff <id>`.
- **No argument**: review all local changes on the current branch — committed, staged, and unstaged —
  against the branch it was forked from. Run `git fetch` first, then diff against the merge base
  with the remote default branch: `git diff $(git merge-base origin/HEAD HEAD)`. Warn at the top of
  the review, and still review everything, if any of these hold:
  - uncommitted or staged changes not yet committed
  - local commits not pushed to the remote (branch is ahead)
  - branch is behind its upstream and needs a pull

Review against what the change is trying to achieve, not an imagined rewrite. Calibrate severity by
*code health*: does the change improve it, not is it perfect. Leave formatting to the linter or
formatter that owns it. Where code is unclear, ask rather than guess at a bug.

## Reporting

A short list, most severe first, each a Conventional Comment (`review-comments` skill, read
`~/.config/agent/skills/review-comments/SKILL.md`) giving the file/line, the subject, and a concrete
fix in the discussion. Mark must-fix findings `(blocking)` and optional ones `(non-blocking)`. If the
code looks good, say so briefly with a `praise` comment for genuinely good work. Modify no files.
