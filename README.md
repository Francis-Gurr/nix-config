# nix-config

Declarative user environment built on standalone [Home Manager](https://github.com/nix-community/home-manager). One config for a Fedora workstation now and NixOS later.

Standalone means Home Manager manages the user environment only. It needs no NixOS and no root once Nix itself is installed.

## Layout

```
flake.nix              inputs, homeConfigurations, checks, devShell
home/
  common.nix           shared base; imports everything below
  linux.nix            x86_64-linux entry point
  agent.nix            ~/.config/agent and ~/.claude
  git.nix              git, delta, lazygit
  kitty.nix            terminal
  neovim.nix           neovim and its tooling
  obsidian.nix         editor app and its declarative settings
  packages.nix         CLI tools and fonts
  shell.nix            zsh, fzf, direnv
  starship.nix         prompt
  agent/               agent docs and skills, deployed read-only
  claude/              Claude Code settings
  nvim/                neovim config, symlinked to the working tree
```

One file per concern. `common.nix` holds only the shared base: `username`, `stateVersion`, and the import list. `linux.nix` carries the home directory and anything OS-specific, such as `imv` and `wl-clipboard`.

## Set up a new machine

**Clone to exactly `~/dev/nix-config`.** `home/neovim.nix` symlinks `~/.config/nvim` at that path, so any other location leaves neovim without a config. This is the only place the config is not location-independent.

### 1. Install Nix

```bash
sudo dnf install nix
```

Fedora's package enables flakes already. It ships no SELinux policy for `/nix`, though, so the daemon socket cannot start until the directory is labelled:

```bash
sudo semanage fcontext -a -t var_run_t '/nix/var/nix/daemon-socket(/.*)?'
sudo restorecon -RFv /nix/var/nix/daemon-socket
sudo systemctl enable --now nix-daemon.socket
```

The service staying `inactive` afterwards is correct — it is socket-activated. Verify with `nix store ping`.

Installing needs `sudo`. Applying the config afterwards never does.

### 2. Clone and apply

```bash
git clone git@github.com:Francis-Gurr/nix-config.git ~/dev/nix-config
cd ~/dev/nix-config
nix build '.#homeConfigurations."francis@linux".activationPackage' && ./result/activate
```

Use the flake's own pinned Home Manager rather than `nix run home-manager`, which resolves from the flake registry and tracks `master` — a different Home Manager from the one this config is written against. After the first activation, `home-manager switch --flake .#francis@linux` is on `PATH` and equivalent.

If a config file already exists, activation refuses to overwrite it. Move it aside instead:

```bash
HOME_MANAGER_BACKUP_EXT=pre-hm ./result/activate
```

That only catches paths Home Manager writes to directly. It will not notice a file that *shadows* one — `~/.gitconfig` overrides `~/.config/git/config`, for instance, and has to be moved by hand.

### 3. Finish by hand

Nix installs tools; it does not log you in.

- `chsh -s $(command -v zsh)`.
- `gh auth login`, and any other interactive one-time auth.
- Install any app plugins that carry their own credentials. Those settings stay out of this repo, so they cannot be declared here.

Reopen your terminal so the profile lands on `PATH`.

## Day to day

Edit a file under `home/`, then rebuild and activate:

```bash
nix build '.#homeConfigurations."francis@linux".activationPackage' && ./result/activate
```

Deployed config is read-only, because it lives in the Nix store. Editing `~/.config/agent/AGENTS.md` fails rather than silently doing nothing — the source is `home/agent/AGENTS.md` and the change needs a rebuild.

Two directories are the exception, symlinked to the working tree instead: `home/nvim`, because `vim.pack` writes its lockfile back into its own config directory, and anything else a tool insists on writing. Prefer store copies otherwise.

Flakes only see git-tracked files, so `git add` a new file before building it.

## Development

```bash
nix develop     # or just cd in, if direnv is set up
```

The shell brings the linters and `pnpm`, and installs the git hooks:

| Stage | Runs |
|---|---|
| `pre-commit` | `nixfmt-rfc-style`, `statix`, `deadnix` |
| `commit-msg` | `commitlint` |
| `pre-push` | `nix flake check` |

`nix flake check` is on push rather than commit because it is much heavier than the linters, and committing should stay fast.

Commits follow Conventional Commits with a leading gitmoji, subject line only — `commitlint.config.mjs` is the authority, and the `commit-msg` hook enforces it.

## Conventions

Each `home/*.nix` file owns one concern and is imported by `common.nix`. Adding a tool means a new file there plus one line in the import list, not a section appended to an existing module.

Config is transcribed into Nix options rather than copied verbatim — `programs.starship.settings` as an attrset, not `readFile` on a TOML file. Typed options catch mistakes at build time and Home Manager handles the ordering constraints, so prefer a module over `home.file` whenever one exists.
