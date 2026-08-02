---
name: obsidian-plan
description: Use when planning work into my Obsidian vault, tracking status, or resuming from a plan. Plans belong in the vault, not in the repo or ~/.claude/plans. Includes a mandatory review gate before any plan is approved.
---

Read `~/.config/agent/skills/obsidian-notes/SKILL.md` for vault conventions and
`~/.config/agent/skills/obsidian-project/SKILL.md` for resolving project and task. Do not duplicate
that logic here. Write with the `caveman` skill.

## A plan is a status, not a shape

There are only areas, projects, workstreams and tasks, all with the same three sections. Approving a
plan means writing its content into that structure — never adding `Approach`, `Decisions` or
`Review` headings, never creating a standalone plan note.

| Plan content | Lands in |
|---|---|
| Goal, and how the work is shaped | `## Summary` of the workstream or task |
| The actual work | `## Steps` on each task |
| Decisions, including rejected ones | `## Notes`, at the level it applies to |
| Review findings | `## Notes` of whatever was reviewed |

Plan a **task** when the work is one piece; a **workstream** when it spans several. Create the note
via `obsidian-project` first if none exists.

**A workstream-sized plan creates its tasks at the same time**, each from `Templates/Task.md` with
`project`, `workstream` and `order`. Deferring them leaves the workstream as one opaque note.

**Name tasks for what they do** — `Bootstrap`, `Home Manager` — never `Phase 1 - …`. Prefixes collide
across workstreams and repeat the `type`. Sequence goes in `order`, which renumbers without the CLI
rename a rename would need.

Do not restate the task list in the workstream's `## Summary`; the `## Tasks` block derives it.
Per-task detail like "done when the VM boots" belongs on that task.

Status: `draft` while planning and under review → `todo` once the gate passes → `in-progress` once
work starts. Tasks start at `todo` alongside their workstream. **Revising a plan edits the same
notes** — never create a second one.

Record decisions in `## Notes`, including the ones *not* taken and why. That is the part worth having
in six months; the steps will be obvious from the diff.

## The review gate

**No plan is approved without a subagent review pass**, in this order:

1. Draft the plan.
2. Francis reviews and comments. Iterate.
3. **Only once he says he is happy**, spawn the review subagent.

Never run it earlier — findings on a churning plan go stale before he has finished commenting.

Use a read-only subagent (`Plan` type), giving it every note being planned and the repo it targets.
It checks the plan **against reality**, not for style:

- Do the named files, functions and paths exist?
- Are the steps executable in the order given?
- Do any steps contradict each other?
- What does it assume without saying?
- Would the verification actually catch a failure, or is it "look and see"?

Record findings in `## Notes` on whatever was reviewed, with what was done about each — **including
those deliberately not acted on, and why**. Keep to findings that changed something or that someone
would hit again; a full transcript helps nobody.

Report to Francis. Material findings send the plan back to `draft` rather than through. Only once
they are resolved does `status` become `todo`.

Not ceremony: on the plan that built this vault, the gate caught a note type that matched no view, an
embed that would have rendered one view instead of six, and CLI commands missing `vault=` that could
have written to the wrong vault.

Know its blind spot — it checks whether a plan is *true*, not whether it fits these conventions. It
passed a plan whose tasks were all named `Phase N - …`, because nothing about naming was false.

## Multiple workstreams

Plan every workstream at once, all in `draft`, and have the review subagent check the whole plan
together — cross-workstream contradictions only surface when the workstreams are read side by side.

Promotion is separate from the review and runs in dependency order. Move a workstream to `todo` only
when nothing it depends on — nothing earlier in its `order` — is still unfinished. A later workstream
stays `draft` even after it has passed review, because finishing the earlier work can change it.

So before picking up the next workstream, run the planning and review stage again for it: re-read it
against what the finished work actually produced, amend it, then promote `draft` → `todo`. A
workstream last reviewed against an unbuilt dependency has not really been checked.

## Resuming

Tick `## Steps` as work proceeds — the checkboxes plus the task and workstream statuses are the whole
record of what is done and what is left. Keep no dated progress log: it would only restate what the
statuses already show.

**Done means pushed.** A ticked step, a task at `done` and a workstream at `done` all assert that the
work behind them is committed and on the remote — not merely working in a local tree. Commit and push
first, then tick the step or move the status. Where the work is finished but unpushed, say so and
leave the box and the status alone. Code that exists only in a working tree can still be lost or
rewritten, so a record that counts it as delivered is claiming something the remote cannot show.

When resuming, read the in-progress task and its `## Notes` (Decisions, Review) **before doing
anything**, and report where things stand from the statuses and the ticked steps. Do not restart from
step one.

Record anything learned that contradicts the plan in `## Notes` — a decision that turned out wrong is
more useful written down than quietly corrected.
