---
name: obsidian-notes
description: Conventions for my Obsidian vaults (personal and shared). Use when reading or writing any vault note: folder structure, frontmatter, note shape, naming, archiving and file operations. Read by obsidian-project, to-workstream, to-tasks, review-plan, implement, research and retro.
---

Write notes with the `writing` skill.

## Vaults

Two vaults share one structure. Every CLI call names its vault.

| Vault | Path | CLI | Dev projects |
|---|---|---|---|
| personal | `~/notes/personal` | `vault="personal"` | `obsidian://open?vault=personal&file=Areas%2FDevelopment` |
| shared | `~/notes/shared` | `vault="shared"` | `obsidian://open?vault=shared&file=Areas%2FDevelopment` |

**Choosing a vault:** use the vault that already holds the project. New projects go to personal unless I say shared. A vault is present only if its directory holds `.git`: Home Manager writes `.obsidian/` on every machine, but only NixOS syncs. When searching, skip an absent vault. Stop and say so only when the vault you need to write to is absent: a note written there never syncs.

## Structure

```
Areas/                ongoing groupings that never finish; Development holds the dev projects
Projects/<project>/   active work: a hub note named for the folder, plus its workstreams and tasks
Archive/Projects/<project>/   finished workstreams, tasks and projects, same layout
Resources/            external material tied to no project
Templates/            start every note from one of these
Attachments/
Todos.md              the only place loose todos live
Dashboard.md          views from Active.base and Archive.base, plus Todos
```

**A project is a repo.** Non-code projects are projects without a remote. Two folder levels below `Projects/` at most.

**Search `Projects/` for live work.** `Archive/` holds finished work; read it only when asked about past work. Archiving is in the `obsidian-project` skill.

**Where a note goes:** a repo file if someone cloning the repo needs it (README, ADR); the `## Notes` of the relevant task, workstream, project or area if it is my own understanding; `Resources/` if it is external material tied to no project.

## Frontmatter

One `status` vocabulary for every type: `draft` → `todo` → `in-progress` → `blocked` → `done` / `cancelled`. The Stale view derives "paused" from `file.mtime`, so there is no `paused` status.

| Type | Properties |
|---|---|
| `area` | `status` |
| `project` | `status`, `area` (link), `remote` |
| `workstream` | `status`, `project` (link), `order` |
| `task` | `status`, `project` (link), `workstream` (link), `order` |
| `note` | `project` (link), `source` |

`remote` is the normalised git origin: `github.com/Francis-Gurr/nix-config`, scheme and `.git` stripped. Omit it for non-code projects.

`area`, `project` and `workstream` are links, so quote them: `area: "[[Development]]"`. `type` and `status` stay plain strings; linking them would create empty stub notes. A task carries `project` even when it has a `workstream`, so Bases can group by project without following a link.

`order` is a **required** integer on every task and workstream, default `0`. Number siblings `0, 1, 2 …` where they run in sequence; give siblings that can run in parallel the same value, and the view sorts them by name. Sequence lives in `order`, never in the filename.

Keep a sometimes-unset property **blank**, so the note carries the same keys as its template.

## Note shape

**Every note has exactly three sections**: what it is, what is under it, everything else.

| Type | Sections |
|---|---|
| `area` | `## Summary` · `## Projects` (derived) · `## Notes` |
| `project` | `## Summary` · `## Work` (derived) · `## Notes` |
| `workstream` | `## Summary` · `## Tasks` (derived) · `## Notes` |
| `task` | `## Summary` · `## Steps` (checkboxes) · `## Notes` |
| `note` | `## Summary` · `## Details` |

**Put information at the lowest level it belongs.** A gotcha found doing one task goes in that task's `## Notes`. Move it up only when it affects sibling tasks, and again only when it affects other workstreams. Retrospectives go under `### Retro` in `## Notes`.

**A project folder holds only projects, workstreams and tasks.** `type: note` lives in `Resources/`.

**The structure carries the links.** Properties link upward, derived tables link downward, and the type is in frontmatter, so the prose skips "this is a task under X".

## Writing notes

- Start at `##`: Obsidian renders the filename as the title.
- Templates carry the shape as `%%` prompts: replace each with what it asks for, so a finished note has none.
- Plans leave out file paths and code snippets unless a step cannot be stated without one: they go stale. A prototype's snippet that states a decision more precisely than prose (a state machine, a schema, a type) goes under that decision, trimmed to the decision-rich part.
- One line per paragraph, no hard wrapping.
- Sentence case with spaces (`Setup rust lsp.md`). A project folder matches the repo name in the remote, not the name of the checkout directory.
- `[[wikilinks]]` inside the vault, Markdown links for external URLs.
- Checkboxes belong to a task's `## Steps`. Only `Todos.md` holds todos.
- **Lists are derived.** A ` ```base ` block filtered on `workstream == this` cannot drift, because the table is the frontmatter. Each level lists only what it owns: an area its projects, a workstream its tasks, a project its workstreams plus any task with no workstream (`workstream.isEmpty()`). Before editing a base block, read [`REFERENCE.md`](REFERENCE.md#base-views).

Syntax worth knowing: `[[Note#Heading]]`, `[[Note|display]]`, `![[Note]]`, `![[Active.base#View]]` to embed one view, `> [!note]` callouts, `==highlight==`, `%%comment%%`.

## File operations

**Create and edit** with normal file tools; Obsidian watches the filesystem.

**Rename, move and delete** through the CLI, which rewrites inbound wikilinks; `mv` and `rm` silently orphan them.

```
obsidian vault="<vault>" rename file=<name> name=<new>
obsidian vault="<vault>" move   file=<name> to=<path>
obsidian vault="<vault>" delete file=<name>
```

`move` fails with `ENOENT` unless the destination folder exists, so `mkdir -p` it first.

`vault=` is **mandatory**: both vaults can be open at once, and without it a rename can hit the wrong one. If the CLI is unavailable, say what needs renaming and leave it. If it fails with `Cannot find module 'electron'`, or you need to edit `.obsidian/*.json`, read [`REFERENCE.md`](REFERENCE.md).
