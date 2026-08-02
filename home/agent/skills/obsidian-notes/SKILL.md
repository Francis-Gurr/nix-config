---
name: obsidian-notes
description: Use when reading or writing notes in my personal Obsidian vault — folder structure, frontmatter, note shape, naming, and Obsidian-flavoured Markdown. Read by the obsidian-project and obsidian-plan skills.
---

Vault is `~/Documents/francis-notes/francis`. **If it does not exist, say so and stop** — do not
create it. It is absent on work machines, and a fake vault produces notes that never sync. The
shared vault (`~/Documents/shared-notes/shared-notes`) is out of scope.

Write notes with the `caveman` skill: tight prose, no filler.

## Structure

```
Areas/         ongoing groupings that never finish — one per employer or life domain
Projects/      one folder per repo, or per non-code endeavour
  <project>/   hub note named for the folder, plus its workstreams and tasks
Resources/     external material tied to no project
Templates/     start here rather than inventing a note shape
Attachments/
Todos.md       the only place loose todos live
Dashboard.md   Projects / Board / Stale views, plus Todos
Active.base    the view definitions
```

**A project is a repo.** Non-code projects (a quilt, a D&D campaign) are projects without a remote.
Two folder levels, never three. Nothing is moved or archived — `status: done` plus the Bases filters
do the hiding.

**Where a note goes:** a repo file if someone cloning the repo needs it (README, ADR); the `## Notes`
of the relevant task, workstream, project or area if it is your own understanding; `Resources/` if it
is external material tied to no project.

## Frontmatter

One `status` vocabulary for every type: `draft` → `todo` → `in-progress` → `blocked` → `done` /
`cancelled`. No `paused` — the Stale view derives that from `file.mtime`.

| Type | Properties |
|---|---|
| `area` | `status` |
| `project` | `status`, `area` (link), `remote` |
| `workstream` | `status`, `project` (link), `order` |
| `task` | `status`, `project` (link), `workstream` (link), `order` |
| `note` | `project` (link), `source` |

`remote` is the normalised git origin — `github.com/Francis-Gurr/dotfiles`, scheme and `.git`
stripped. **Never a filesystem path**: paths differ per machine and would fail exactly where
portability matters. Omit for non-code projects.

`area`, `project` and `workstream` are links, so they need quoting: `area: "[[Personal dev]]"`.
`type` and `status` stay plain strings — schema enums, not concepts; linking them would create empty
stub notes. `project` is set on a task even when `workstream` is, so Bases can group by project
without following a link it cannot traverse.

`order` is a **required** integer on every task and workstream, default `0`. Number siblings
`0, 1, 2 …` where they run in sequence; leave them all `0` where they don't, which says "equivalent"
and lets the view fall back to sorting by name. It exists so ordering never lands in a filename:
`Phase 1 - Bootstrap` collides across workstreams, repeats the `type`, and needs a CLI rename to
reorder.

**Keep a property blank rather than deleting it** when it is sometimes unset — a note should carry
the same keys as its template, so the properties panel prompts you. Bases treats blank and absent
alike, so this is for your benefit, not the queries'. This does not extend to properties that only
apply in a context the note is never in; those stay off the shared template entirely.

**No work-specific property yet.** The Jira key already leads the note title, so `ticket` would
duplicate it, and whether a clickable `url` earns its place is undecided until there are real
tickets.

## Note shape

**Every note has exactly three sections** — what it is, what is under it, everything else:

| Type | Sections |
|---|---|
| `area` | `## Summary` · `## Projects` (derived) · `## Notes` |
| `project` | `## Summary` · `## Work` (derived) · `## Notes` |
| `workstream` | `## Summary` · `## Tasks` (derived) · `## Notes` |
| `task` | `## Summary` · `## Steps` (checkboxes) · `## Notes` |
| `note` | `## Summary` · `## Details` |

**Planned work has no separate shape.** A plan adds no `Approach`, `Decisions`, `Review` or
`Progress` sections. Its content distributes: how the work is shaped goes in `## Summary`, the work
becomes tasks with `## Steps`, and decisions, review findings and progress go in `## Notes` at the
level they apply to.

**Put information at the lowest level it belongs.** A gotcha found doing one task belongs in that
task's `## Notes`. Move it up only when it affects sibling tasks, and up again only when it affects
other workstreams. Most things never move.

**A project folder holds only projects, workstreams and tasks.** Never add a `type: note` alongside
them — it sits between the real work and belongs to none of it. `type: note` is for `Resources/`.

**Never restate what the structure already says.** No "full spec in [[the workstream]]", no "this is
a task under X". The properties link upward, the derived tables link downward, and the type is in
frontmatter.

## Writing notes

- **No `# H1`** — Obsidian renders the filename as an inline title, so a matching H1 shows twice.
  Start at `##`.
- **One line per paragraph**, no hard wrapping.
- Sentence case with spaces (`Setup rust lsp.md`); work notes lead with the Jira key. A project
  folder matches the repo name from the remote — `dotfiles`, not `chezmoi`.
- `[[wikilinks]]` inside the vault, Markdown links for external URLs.
- Checkboxes belong to a task's `## Steps`. Only `Todos.md` holds todos.
- **Lists are derived, never hand-written** — a ` ```base ` block filtered on `workstream == this`
  cannot drift, because the table is the frontmatter. Each level lists only what it owns: an area
  its projects, a workstream its tasks, a project its workstreams plus any task with no workstream
  (`workstream.isEmpty()`).

In a base view `order:` sets the **columns**, not the rows. Sorting needs a separate `sort:` key,
which the published docs omit but the app supports:

```yaml
    order:            # columns, left to right
      - order
      - file.name
      - status
    sort:             # actual row order
      - property: order
        direction: ASC
```

Syntax worth knowing: `[[Note#Heading]]`, `[[Note|display]]`, `![[Note]]`, `![[Active.base#View]]`
to embed one view, `> [!note]` callouts, `==highlight==`, `%%comment%%`.

## File operations

**Create and edit** with normal file tools — Obsidian watches the filesystem, so this works headless
and over SSH.

**Rename, move and delete** go through the CLI. Obsidian only rewrites inbound wikilinks when the
operation goes through it; an external `mv` reads as delete-plus-create and silently orphans every
link.

```
obsidian vault="francis" rename file=<name> name=<new>
obsidian vault="francis" move   file=<name> to=<path>
obsidian vault="francis" delete file=<name>
```

`vault="francis"` is **mandatory** — both vaults are open at once, and without it a rename can hit
the shared one. Never `mv` or `rm` a note. If the CLI is unavailable, say what needs renaming and
leave it; a deferred rename beats silently broken links.

`.obsidian/*.json` is the exception: the running app holds config in memory and overwrites those
files on exit, so they can only be edited with Obsidian closed. Anything needed while it runs goes
through Settings.
