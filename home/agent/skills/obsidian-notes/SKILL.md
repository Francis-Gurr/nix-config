---
name: obsidian-notes
description: Use when reading or writing notes in my personal Obsidian vault.
---

Vault is `~/notes/personal`. **If it does not exist, say so and stop**: it is absent on work
machines, and a new vault produces notes that never sync. The shared vault (`~/notes/shared`) is out
of scope.

Write notes with the `caveman` skill.

## Structure

```
Areas/         ongoing groupings that never finish — one per employer or life domain
Projects/      one folder per repo, or per non-code endeavour
  <project>/   hub note named for the folder, plus its workstreams and tasks
Resources/     external material tied to no project
Templates/     start every note from one of these
Attachments/
Todos.md       the only place loose todos live
Dashboard.md   Projects / Board / Stale views, plus Todos
Active.base    the view definitions
```

**A project is a repo.** Non-code projects (a quilt, a D&D campaign) are projects without a remote.
Two folder levels at most. Notes stay where they are when finished: `status: done` plus the Bases
filters do the hiding.

**Where a note goes:** a repo file if someone cloning the repo needs it (README, ADR); the `## Notes`
of the relevant task, workstream, project or area if it is your own understanding; `Resources/` if it
is external material tied to no project.

## Frontmatter

One `status` vocabulary for every type: `draft` → `todo` → `in-progress` → `blocked` → `done` /
`cancelled`. The Stale view derives "paused" from `file.mtime`, so there is no `paused` status.

| Type | Properties |
|---|---|
| `area` | `status` |
| `project` | `status`, `area` (link), `remote` |
| `workstream` | `status`, `project` (link), `order` |
| `task` | `status`, `project` (link), `workstream` (link), `order` |
| `note` | `project` (link), `source` |

`remote` is the normalised git origin — `github.com/Francis-Gurr/dotfiles`, scheme and `.git`
stripped. Omit it for non-code projects.

`area`, `project` and `workstream` are links, so they need quoting: `area: "[[Personal dev]]"`.
`type` and `status` stay plain strings; linking them would create empty stub notes. `project` is set
on a task even when `workstream` is, so Bases can group by project without following a link.

`order` is a **required** integer on every task and workstream, default `0`. Number siblings
`0, 1, 2 …` where they run in sequence; leave them all `0` where they don't, and the view sorts by
name. Sequence lives in `order`, never in the filename.

Keep a sometimes-unset property **blank**, so the note carries the same keys as its template. Add no
`ticket` or `url` property: the Jira key already leads the note title.

## Note shape

**Every note has exactly three sections** — what it is, what is under it, everything else:

| Type | Sections |
|---|---|
| `area` | `## Summary` · `## Projects` (derived) · `## Notes` |
| `project` | `## Summary` · `## Work` (derived) · `## Notes` |
| `workstream` | `## Summary` · `## Tasks` (derived) · `## Notes` |
| `task` | `## Summary` · `## Steps` (checkboxes) · `## Notes` |
| `note` | `## Summary` · `## Details` |

**Put information at the lowest level it belongs.** A gotcha found doing one task belongs in that
task's `## Notes`. Move it up only when it affects sibling tasks, and up again only when it affects
other workstreams.

**A project folder holds only projects, workstreams and tasks.** `type: note` lives in `Resources/`.

**The structure carries the links.** Properties link upward, derived tables link downward, and the
type is in frontmatter, so the prose skips "this is a task under X".

## Writing notes

- Start at `##`: Obsidian renders the filename as the title.
- One line per paragraph, no hard wrapping.
- Sentence case with spaces (`Setup rust lsp.md`); work notes lead with the Jira key. A project
  folder matches the repo name from the remote — `dotfiles`, not `chezmoi`.
- `[[wikilinks]]` inside the vault, Markdown links for external URLs.
- Checkboxes belong to a task's `## Steps`. Only `Todos.md` holds todos.
- **Lists are derived** — a ` ```base ` block filtered on `workstream == this` cannot drift, because
  the table is the frontmatter. Each level lists only what it owns: an area its projects, a
  workstream its tasks, a project its workstreams plus any task with no workstream
  (`workstream.isEmpty()`). Editing a base block: read [`REFERENCE.md`](REFERENCE.md#base-views).

Syntax worth knowing: `[[Note#Heading]]`, `[[Note|display]]`, `![[Note]]`, `![[Active.base#View]]`
to embed one view, `> [!note]` callouts, `==highlight==`, `%%comment%%`.

## File operations

**Create and edit** with normal file tools — Obsidian watches the filesystem.

**Rename, move and delete** go through the CLI, which rewrites inbound wikilinks; `mv` and `rm`
silently orphan them.

```
obsidian vault="personal" rename file=<name> name=<new>
obsidian vault="personal" move   file=<name> to=<path>
obsidian vault="personal" delete file=<name>
```

`vault="personal"` is **mandatory** — both vaults are open at once, and without it a rename can hit
the shared one. If the CLI is unavailable, say what needs renaming and leave it. If it fails with
`Cannot find module 'electron'`, or you need to edit `.obsidian/*.json`, read
[`REFERENCE.md`](REFERENCE.md).
