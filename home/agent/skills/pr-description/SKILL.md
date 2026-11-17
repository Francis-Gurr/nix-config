---
name: pr-description
description: Use when writing a pull/merge request description.
---

Write for the reviewer, and for the future reader who finds this PR through git blame. The diff shows
*what* changed line by line; the description adds what the diff can't. A reviewer should grasp the
change in seconds.

## Structure

Include only the sections that carry information; omit empty ones entirely.

- **Summary** — 1–3 sentences: what the change does and the problem it solves, at a high level.
- **Why** — only when the approach isn't obvious from the code: the rationale, the tradeoff, or the
  alternative you rejected and why.
- **Testing** — how you verified it and what the reviewer should exercise: commands run, scenarios
  covered, edge cases.

Add only when relevant:

- **Linked issue/ticket** reference.
- **Out of scope / follow-ups** — what you deliberately left for later.
- **Risk / review focus** — areas you're unsure about or want looked at hardest.
- **Breaking changes / migration / deploy** notes.
- **Screenshots** — for user-facing UI changes.

## Writing it

- Derive the change from the diff (the `review` skill's "What to review" resolves the scope), and
  describe intent rather than the edits.
- When you don't know why a decision was made, ask.
- Produce the description text only. Open the PR/MR (`gh pr create` / `glab mr create`) only when I
  explicitly ask.
