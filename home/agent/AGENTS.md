# Global agent preferences

These docs and skills are sourced from `~/dev/nix-config/home/agent/` and deployed read-only by Home Manager; edit the source, then rebuild. Write them with the `writing-for-agents` skill.

## Git

- Commit only when I ask. Stage the changes and pause so I can review them; on my approval, commit and push together without asking again.
- Never commit or push in my Obsidian vaults: `git-sync` commits and pushes every change itself.
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
- On NixOS, give rebuild commands as `nh` (`nh os switch`), never `nixos-rebuild`: `nh` is installed with the flake path set.
- Claude desktop sessions run sandboxed, without sudo or direnv: give me root steps such as `nh os switch` as commands to run, and run devShell tools through `direnv exec .`.
- Picking tools or apps: give a short comparison and one recommendation. Stay close to the defaults and de facto standards of the stack in use; stray only when necessary. I want minimal, simple to configure in Nix, themable, popular and well maintained. Check recent commits before recommending; a repo idle for a year or more is out.
