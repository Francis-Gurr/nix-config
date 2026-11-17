# Editing agent docs

Check where `~/.config/agent` points; that decides which source to edit.

- **A symlink into `/nix/store`** — Home Manager. Edit `~/dev/nix-config/home/agent/`, then rebuild
  and activate. The deployed copy is read-only.
- **A real directory** — chezmoi. Edit `~/.local/share/chezmoi/dot_config/agent/`, then
  `chezmoi apply ~/.config/agent`. A direct edit to `~/.config/agent/` is reverted by the next apply.

The two copies diverge until every machine runs Nix; port changes across deliberately.
