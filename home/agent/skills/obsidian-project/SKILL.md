---
name: obsidian-project
description: Use when finding or creating a project, workstream or task in my Obsidian vault, updating the status of work, or resuming it.
---

Read `~/.config/agent/skills/obsidian-notes/SKILL.md` first for vault structure, frontmatter and
file operations.

## Resolving the project

A named project always wins. Otherwise:

1. `git remote get-url origin`, normalised — strip the scheme, `git@` and trailing `.git`, so SSH and
   HTTPS clones agree. Match against `remote:` in `Projects/*/`.
2. Repo with no `origin`: match its directory name against project names.
3. No repo, or no match: **ask**.

Match on the remote, never the filesystem path: a repo can be cloned anywhere, and a work machine
lacks the personal ones. Step 3 is common — non-code projects and the `Obsidian vault` project have
no remote.

## Resolving the task

A Jira key in the branch (`PROJ-101-rate-limiter`) resolves straight to that task. Otherwise ask, or
create one. Personal work happens on `main` with no key, so asking is the normal path there.

## Sizing

Size the work *before* writing anything:

1. **A line in `Todos.md`** — trivial, or not yet attached to a project. Most small things stop here.
2. **A task note** — when it needs its own context, learnings, or a resumable status.
3. **A task or workstream in `draft`** — multi-step, or with decisions worth recording: the
   `obsidian-plan` skill.

A workstream needs at least three tasks. Promote between tiers when asked, or when the work turns out
bigger than it looked.

## Creating

**Project** — `Projects/<repo-name>/<repo-name>.md` from `Templates/Project.md`, named for the repo
**in the remote, not the directory**: `~/.local/share/chezmoi` with remote `…/dotfiles` becomes
`dotfiles`. Link it from its area note.

For `area`: a work remote owner or a `~/dev/work/*` checkout means the employer area; any other repo
goes in the personal code area. Ask only when there is no repo.

**Workstream** — only when enough tasks accumulate to need shared context, or immediately when Jira
has an epic. Tasks attach directly to a project otherwise.

**Task** — from `Templates/Task.md`, carrying `project`, `order` and any `workstream`.

## Updating status

Keep `status` current on the task and its workstream — the derived tables and the Board read from
it. What to pick up next is whatever is `in-progress`; why you stopped goes in that note's
`## Notes`. Set `blocked` as soon as work stalls on someone else.

Tick `## Steps` as work proceeds; the checkboxes and statuses are the whole record of progress.

**Done means pushed.** A ticked step or a `done` status asserts the work is committed and on the
remote. Commit and push first, then tick or change the status. Where the work is finished but
unpushed, say so and leave both alone.

Record anything learned that contradicts the plan in `## Notes`, rather than quietly correcting it.

## Resuming

Read the in-progress task, its `## Notes` and its workstream's `## Notes`, then **report where things
stand from the statuses and ticked steps before doing any work**. Continue from the first unticked
step.
