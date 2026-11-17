# Global agent preferences

Editing this file, `STYLE.md` or any skill: read `~/.config/agent/EDITING.md` first.

## Git

- Commit only when I explicitly ask — except edits to my Obsidian vault, which you commit and push
  straight away.
- Keep history linear: rebase rather than merge.
- Push with `--force-with-lease` only when I explicitly ask; plain `--force` never.

## Plans

Offer to save every drafted or approved plan to my Obsidian vault with the `obsidian-plan` skill.

## Code style

@~/.config/agent/STYLE.md

## Working style

- Be concise. Lead with the answer, then the reasoning if needed.
- Picking tools or apps: give a short comparison and one recommendation. Stay close to the defaults
  and de facto standards of the stack in use; stray only when necessary. I want minimal, simple to
  configure in Nix, themable, popular and well maintained — check recent commits before
  recommending; a repo idle for a year or more is out.
