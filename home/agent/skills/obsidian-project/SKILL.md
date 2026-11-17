---
name: obsidian-project
description: Find, create, size, resume and archive projects, workstreams and tasks in my Obsidian vaults, and keep their status current. Use when starting, resuming or finishing tracked work.
---

Read `~/.config/agent/skills/obsidian-notes/SKILL.md` first for vaults, structure, frontmatter and file operations.

## Resolving the project

A named project always wins. Otherwise:

1. `git remote get-url origin`, normalised: strip the scheme, `git@` and trailing `.git`, so SSH and HTTPS clones agree. Match it against `remote:` in `Projects/*/` of each vault present.
2. Repo with no `origin`: match its directory name against project names.
3. No repo, or no match: **ask**.

Match on the remote, never the filesystem path: a repo can be cloned anywhere. Step 3 is common, because non-code projects have no remote.

## Resolving the task

The task I name wins. Otherwise use the project's `in-progress` task; with several, or none, ask or create one.

## Sizing

Size the work *before* writing anything:

1. **A line in `Todos.md`**: trivial, or not yet attached to a project. Most small things stop here.
2. **A task note**: when it needs its own context, learnings, or a resumable status.
3. **A planned workstream or task in `draft`**: multi-step, or with decisions worth recording. Grill it with the `grilling` skill, then suggest I run `/to-workstream` and `/to-tasks` to turn it into notes.

A workstream needs at least three tasks. Promote between tiers when asked, or when the work turns out bigger than it looked.

## Creating

**Project**: `Projects/<repo-name>/<repo-name>.md` from `Templates/Project.md`, named for the repo **in the remote, not the directory**. Set `area: "[[Development]]"` for a repo; ask for the area only when there is no repo.

**Workstream**: only when enough tasks accumulate to need shared context. Tasks attach directly to a project otherwise.

**Task**: from `Templates/Task.md`, carrying `project`, `order` and any `workstream`.

## Updating status

Keep `status` current on the task and its workstream; the derived tables and the Board read from it. What to pick up next is whatever is `in-progress`; why you stopped goes in that note's `## Notes`. Set `blocked` as soon as work stalls on someone else.

**Done means pushed.** A ticked step or a `done` status asserts the work is committed and on the remote. Commit and push first, then tick and change the status. Where the work is finished but unpushed, say so and leave both alone. The full path to done is in the `implement` skill.

Record anything learned that contradicts the plan in `## Notes`, rather than quietly correcting it.

## Resuming

Read the in-progress task, its `## Notes` and its workstream's `## Notes`, then **report where things stand from the statuses and ticked steps before doing any work**. Continue from the first unticked step.

## Archiving

Finished work leaves `Projects/` so it stops costing context. Move with the CLI so links survive, into `Archive/Projects/<project>/` (create the folder if absent):

- **A workstream**, after its retro (the `retro` skill): move the workstream note and every task whose `workstream` links to it.
- **A task with no workstream**, once `done` and retro'd: move it alone.
- **A project**, once `done`: move each remaining note into `Archive/Projects/<project>/`, beside anything already archived there, then delete the empty `Projects/<project>/` folder.

Archived notes keep their status and links. The Dashboard lists archived projects through `Archive.base`.
