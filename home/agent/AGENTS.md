# Global agent preferences

These docs and skills are sourced from `~/dev/nix-config/home/agent/` and deployed read-only by Home Manager; edit the source, then rebuild. Write them with the `writing-for-agents` skill.

## Git

- Commit only when I ask. Stage the changes and pause so I can review them; on my approval, commit and push together without asking again.
- My Obsidian vaults are notes, not code: commit and push vault edits straight away.
- Keep history linear: rebase rather than merge.
- Push with `--force-with-lease` only when I ask; plain `--force` never.

## Work

Projects, workstreams and tasks live in my Obsidian vaults (`obsidian-project`). Planned work runs `/grill-me` → `/to-workstream` → `/to-tasks` → `/implement` per task → `/retro`. Plans go in the vault, never in the repo or `~/.claude/plans`.

## Prose

Anything I read later (notes, docs, commit messages, PR bodies) follows the `writing` skill: tight, British English.

## Code

@~/.config/agent/CODING_STANDARDS.md

## Working style

- Lead with the answer, then the reasoning if needed.
- Picking tools or apps: give a short comparison and one recommendation. Stay close to the defaults and de facto standards of the stack in use; stray only when necessary. I want minimal, simple to configure in Nix, themable, popular and well maintained. Check recent commits before recommending; a repo idle for a year or more is out.
