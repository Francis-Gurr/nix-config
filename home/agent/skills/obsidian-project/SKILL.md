---
name: obsidian-project
description: Use when finding or creating a project, workstream or task in my Obsidian vault, or when updating the status of work. Covers how a repo maps to a project and how work is sized.
---

Read `~/.config/agent/skills/obsidian-notes/SKILL.md` first — it defines the vault structure,
frontmatter and file-operation rules. This skill covers finding, creating and updating. Write with
the `caveman` skill.

## Resolving the project

A named project always wins. Otherwise:

1. `git remote get-url origin`, normalised — strip the scheme, `git@` and trailing `.git`, so SSH and
   HTTPS clones agree. Match against `remote:` in `Projects/*/`.
2. Repo with no `origin`: match its directory name against project names.
3. No repo, or no match: **ask**. Never guess.

One repo is one project, so this is unambiguous on any machine. **Never match on filesystem path** —
a repo can be cloned anywhere, and a work machine will not have the personal ones, so a path fails
precisely where portability is the point.

Reaching step 3 is normal: sewing projects, D&D campaigns and reference notes have no repo, and the
`Obsidian vault` project deliberately has no remote.

## Resolving the task

A Jira key in the branch (`PROJ-101-rate-limiter`) resolves straight to that task. Otherwise ask, or
create one. Personal work happens on `main` with no key, so asking is the normal path there.

## Creating

**Project** — `Projects/<repo-name>/<repo-name>.md` from `Templates/Project.md`, named for the repo
**in the remote, not the directory**: `~/.local/share/chezmoi` with remote `…/dotfiles` becomes
`dotfiles`. Link it from its area note.

For `area`: a work remote owner or a `~/dev/work/*` checkout means the employer area. Any other repo
is a personal code project — do not ask whether it belongs to a non-code area like `Sewing`, which is
never plausible for something with a git remote. Ask only when genuinely torn, or when there is no
repo.

**Workstream** — only when enough tasks accumulate to need shared context, or immediately when Jira
has an epic. Optional; tasks attach directly to a project otherwise.

**Task** — from `Templates/Task.md`, carrying `project`, `order` and any `workstream`.

Never hand-write a task list. The templates carry base blocks that derive their contents.

## Sizing

Size the work *before* writing anything:

1. **A line in `Todos.md`** — trivial, or not yet attached to a project. Most small things stop here.
2. **A task note** — when it needs its own context, learnings, or a resumable status.
3. **A task or workstream in `draft`** — multi-step, or with decisions worth recording. That is the
   `obsidian-plan` skill.

Do not manufacture a task note for a one-line fix, or a workstream for two tasks. Promote between
tiers when asked, or when the work turns out bigger than it looked.

## Updating status

Keep `status` current on the task and its workstream — the derived tables and the Board read from it,
so a stale status makes every view lie. There is no hand-written "next" line: what to pick up is
whatever is `in-progress`, and why you stopped goes in that note's `## Notes`.

Set `blocked` as soon as work stalls on someone else. Unlike a "paused" state, you know the moment it
happens, which is why it is worth recording.

When resuming, read the in-progress task and its workstream `## Notes`, and **report where things
stand before doing any work**. Do not restart something already half done.
