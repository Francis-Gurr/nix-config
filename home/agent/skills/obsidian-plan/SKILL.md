---
name: obsidian-plan
description: Use when planning work, or revising a plan, in my Obsidian vault. Includes the review gate a plan must pass.
---

Read `~/.config/agent/skills/obsidian-notes/SKILL.md` for vault conventions and
`~/.config/agent/skills/obsidian-project/SKILL.md` for resolving the project and task, and for status.

## A plan is a status, not a shape

There are only areas, projects, workstreams and tasks, all with the same three sections. Approving a
plan means writing its content into that structure:

| Plan content | Lands in |
|---|---|
| Goal, and how the work is shaped | `## Summary` of the workstream or task |
| The actual work | `## Steps` on each task |
| Decisions, including rejected ones and why | `## Notes`, at the level it applies to |
| Review findings | `## Notes` of whatever was reviewed |

Plan a **task** when the work is one piece; a **workstream** when it spans several. Create the note
via `obsidian-project` first if none exists.

**A workstream-sized plan creates its tasks at the same time**, each from `Templates/Task.md` with
`project`, `workstream` and `order`. Name tasks for what they do — `Bootstrap`, `Home Manager`; sequence
goes in `order`. Per-task detail like "done when the VM boots" belongs on that task; the workstream's
`## Tasks` block already lists them.

Status: `draft` while planning and under review → `todo` once the gate passes. Tasks start at `todo`
alongside their workstream. **Revising a plan edits the same notes.**

## The review gate

**No plan is approved without a subagent review pass**, in this order:

1. Draft the plan.
2. I review and comment. Iterate.
3. **Once I say I am happy**, check the plan against the `obsidian-notes` conventions yourself (the
   subagent checks truth, not conventions).
4. Spawn a read-only `Plan` subagent, giving it every note being planned and the repo it targets. It
   checks the plan **against reality**:
   - Do the named files, functions and paths exist?
   - Are the steps executable in the order given?
   - Do any steps contradict each other?
   - What does it assume without saying?
   - Would the verification actually catch a failure, or is it "look and see"?
5. Record findings in `## Notes` on whatever was reviewed, with what was done about each — including
   those deliberately not acted on, and why. Keep to findings that changed something or that someone
   would hit again.
6. Report to me. A finding that would change a step, its order or its verification sends the plan
   back to `draft`; `status` becomes `todo` only once every such finding is resolved.

## Multiple workstreams

Plan every workstream at once, all in `draft`, and have the subagent review them together —
cross-workstream contradictions only surface side by side.

Promote in dependency order: a workstream moves to `todo` only once every workstream earlier in its
`order` is `done`. Before picking it up, re-read it against what the finished work actually
produced, amend it, and re-run the gate.
