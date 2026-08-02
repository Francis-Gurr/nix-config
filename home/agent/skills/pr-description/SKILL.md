---
name: pr-description
description: Use when writing a pull/merge request description — a concise summary plus testing notes for the reviewer. Does not restate the diff or open the PR.
---

Write for the reviewer — and the future reader who finds this PR through git blame — not as
a changelog. The diff already shows *what* changed line-by-line; the description adds what
the diff can't. Keep it concise — a reviewer should grasp the change in seconds.

## Structure

Include only the sections that carry information; omit empty ones rather than writing "N/A".

- **Summary** — 1–3 sentences: what the change does and the problem it solves, at a high
  level. Not a list of every edit.
- **Why** — only when the approach isn't obvious from the code: the rationale, the tradeoff,
  or the alternative you rejected and why. Skip it if the code speaks for itself.
- **Testing** — how you verified it and what the reviewer should exercise: commands run,
  scenarios covered, edge cases. Enough that they know what's been tested and what to test.

Add only when relevant:

- **Linked issue/ticket** reference.
- **Out of scope / follow-ups** — what you deliberately left for later.
- **Risk / review focus** — areas you're unsure about or want looked at hardest.
- **Breaking changes / migration / deploy** notes.
- **Screenshots** — for user-facing UI changes.

## Writing it

- Derive the change from the diff (see the `review` skill for how to resolve the scope), but
  describe intent — don't transcribe the edits.
- Don't fabricate rationale; if you don't know why a decision was made, ask rather than guess.
- Produce the description text only. To open the PR/MR, pass it to `gh pr create` /
  `glab mr create` — and only when I explicitly ask.
