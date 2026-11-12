# nix-config

Declarative user environment built on [Home Manager](https://github.com/nix-community/home-manager), with a NixOS system layer. Three outputs share `home/linux.nix`:

| Output | Target | Home Manager runs |
|---|---|---|
| `nixosConfigurations.francisPC` | AMD workstation, NixOS with a Hyprland desktop | as a NixOS module |
| `nixosConfigurations.vm` | NixOS test VM, built from the same base | as a NixOS module |
| `homeConfigurations."francis@linux"` | Fedora, kept as a fallback on the workstation | standalone |

Standalone means Home Manager manages the user environment only. It needs no NixOS and no root once Nix itself is installed.

## Layout

```
flake.nix              inputs, unstable overlay, homeConfigurations, nixosConfigurations, checks, devShell
home/
  linux.nix            x86_64-linux entry point; imports common.nix; Hyprland desktop
  common.nix           shared base; imports the modules below
  agent.nix            ~/.config/agent, ~/.claude and Claude Code
  firefox.nix          Firefox prefs that Sync does not cover
  git.nix              git, delta, lazygit
  kitty.nix            terminal
  neovim.nix           neovim and its tooling
  obsidian.nix         editor app and its declarative settings
  packages.nix         CLI tools, fonts and Bitwarden
  repos.nix            repos cloned into ~/dev on login, via mr
  shell.nix            zsh, fzf, direnv
  ssh.nix              ssh hosts for the homeserver
  vault.nix            Obsidian vault sync, NixOS only
  starship.nix         prompt
  vscode.nix           VS Code with its settings and extensions
  agent/               agent docs and skills, deployed read-only
  claude/              Claude Code settings
  nvim/                neovim config, symlinked to the working tree
  wallpaper.png        desktop wallpaper
hosts/
  common.nix           NixOS base: boot, locale, network and Wi-Fi, audio, Hyprland, greetd, Steam, user
  homeserver-mounts.nix Samba shares, used by every host and again by the VM
  update.nix           nh, its weekly clean, and the `update` command
  francisPC/           the AMD workstation: host settings, hand-written hardware file, SSH key (also used by the VM)
  vm/configuration.nix VM host: disk, memory, display, age key path
.sops.yaml             which age keys secrets.yaml is encrypted to
secrets.yaml           encrypted secrets, edited with sops
```

One file per concern. `common.nix` holds only the shared base: `username`, `stateVersion`, Home Manager itself, and the import list. `linux.nix` carries the home directory and anything OS-specific: the Hyprland session, waybar, the launcher, notifications, the wallpaper, and packages such as `imv` and `wl-clipboard`.

## Install NixOS

From the NixOS graphical installer, as root, with the target root partition mounted at `/mnt` and the ESP at `/mnt/boot`:

```bash
nix-shell -p git
git clone https://github.com/Francis-Gurr/nix-config /mnt/home/francis/dev/nix-config
install -d -m 700 /mnt/var/lib/sops-nix
install -m 600 /dev/stdin /mnt/var/lib/sops-nix/key.txt   # paste the age key from Bitwarden, then Ctrl+D
nixos-install --no-root-passwd --flake /mnt/home/francis/dev/nix-config#francisPC
chown -R 1000:100 /mnt/home/francis
```

A new host needs `hosts/<name>/` and a `mkHost` entry in `flake.nix` first. Its hardware file mounts by label and UUID, so it can be written before formatting.

There is no root password: `mutableUsers` is off and root is reached through `sudo`. zsh is the login shell from the NixOS config, so the `chsh` step below is Fedora-only. On first login, Wi-Fi, the repos, the vault and the SSH key all arrive with nothing done by hand.

## Set up Fedora

**Clone to exactly `~/dev/nix-config`.** `home/neovim.nix` symlinks `~/.config/nvim` at that path, so any other location leaves neovim without a config. This is the only place the config is not location-independent.

**Register an SSH key with GitHub first.** The clone below uses SSH, and `home/git.nix` rewrites `https://github.com/` to SSH for every later git fetch.

**The Hyprland session is NixOS-only for now.** `home/linux.nix` sets `package = null`, so Fedora gets the Hyprland config but no Hyprland. The session's user services still install, and `waybar`, `hyprpaper`, `hyprlauncher` and `hyprpolkitagent` are wanted by `graphical-session.target`, so they start under GNOME too.

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

The service staying `inactive` afterwards is correct — it is socket-activated. Verify with `nix store info`.

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

- `sudo dnf install zsh && chsh -s /usr/bin/zsh`. `chsh` only accepts shells in `/etc/shells`, which excludes the Nix profile's `zsh`. The system `zsh` still reads the config Home Manager writes.
- `gh auth login`, and any other interactive one-time auth.
- Install any app plugins that carry their own credentials. Those settings stay out of this repo, so they cannot be declared here.

Reopen your terminal so the profile lands on `PATH`.

## Run the NixOS VM

The VM decrypts its login password with your age key (see [Secrets](#secrets)). Copy the key into its own directory once, so the VM cannot touch the original:

```bash
mkdir -p ~/.local/share/nixos-vm-key
cp ~/.config/sops/age/keys.txt ~/.local/share/nixos-vm-key/
```

Then build and launch:

```bash
nix build .#nixosConfigurations.vm.config.system.build.vm
SHARED_DIR=~/.local/share/nixos-vm-key nix run --impure github:nix-community/nixGL -- ./result/bin/run-nixos-vm
```

nixGL is needed because Nix-built QEMU cannot load Fedora's Mesa drivers for its GL display.

Log in as `francis` with the password stored in `secrets.yaml`. Without `SHARED_DIR`, the password does not decrypt and login fails. `tuigreet` then starts Hyprland: `SUPER + RETURN` opens kitty and `SUPER + D` opens the launcher. The full bind list is in `home/linux.nix`.

The VM keeps its disk in `./nixos.qcow2`, which is gitignored. Delete that file to start clean. On login, `clone-repos` clones this repo and the others in `home/repos.nix` into `~/dev`, so `~/.config/nvim` resolves once it finishes.

Build `system.build.vmWithBootLoader` instead to boot through a real bootloader.

Everything comes from `nixos-26.05` except three packages taken from `nixos-unstable` by an overlay in `flake.nix`: `claude-code` and its VS Code extension, because stable stopped updating them, and `vscode`, because stable's fails to build. Add to that overlay only when stable cannot serve a package.

Claude desktop comes from the [`aaddrick/claude-desktop-debian`](https://github.com/aaddrick/claude-desktop-debian) flake, which repackages Anthropic's official Linux `.deb` from `downloads.claude.ai`. The config uses its `claude-desktop-fhs` variant, because the app downloads its own `claude` binary and MCP servers, which NixOS cannot run outside an FHS environment. Its repo bumps itself with a bot token, so after `nix flake update` check what changed in the input's `nix/` and `flake.nix` before switching.

Login tokens for Claude desktop, VS Code and other Electron apps live in gnome-keyring, unlocked at login. Apps are dark through `gtk.colorScheme` in `home/linux.nix`.

VS Code settings and extensions are declared in `home/vscode.nix`, so its settings screen cannot save changes. Edit the file and rebuild.

## Day to day

Edit a file, then rebuild and activate. On NixOS, this applies both `hosts/` and `home/`:

```bash
sudo nixos-rebuild switch --flake ~/dev/nix-config#francisPC   # or: nh os switch
```

To update, run `update` (`hosts/update.nix`). It pulls the repo, then `nh os switch --update --ask` moves the inputs in `flake.lock`, builds, shows the package diff and asks before switching. If you accept, it commits and pushes `flake.lock`. If you decline or the build fails, the old pins stay. Last, it applies any device firmware updates from fwupd; one that needs a reboot installs at the next one. Nothing updates on its own. `nh clean` runs weekly and keeps the last five generations plus anything from the past 30 days. Roll back with `sudo nixos-rebuild switch --rollback`, or hold Space at boot.

On Fedora, only `home/` applies:

```bash
nix build '.#homeConfigurations."francis@linux".activationPackage' && ./result/activate
```

For the VM, rebuild it as above and restart it.

Deployed config is read-only, because it lives in the Nix store. Editing `~/.config/agent/AGENTS.md` fails rather than silently doing nothing — the source is `home/agent/AGENTS.md` and the change needs a rebuild.

`home/nvim` is the one exception, symlinked to the working tree because `vim.pack` writes its lockfile back into its own config directory. Edits there apply without a rebuild. Prefer store copies for anything else, unless a tool insists on writing to its config.

Flakes only see git-tracked files, so `git add` a new file before building it.

## Secrets

Secrets live encrypted in `secrets.yaml`, managed by [sops-nix](https://github.com/Mic92/sops-nix). Every machine decrypts them at boot with the same personal age key. The private half lives at `~/.config/sops/age/keys.txt` on Fedora and in Bitwarden, and never in this repo.

Edit secrets from the devShell. `sops` decrypts the file into your editor and re-encrypts it on save:

```bash
sops secrets.yaml
```

The login password is a hash, not the password itself. Generate one with `nix shell nixpkgs#mkpasswd -c mkpasswd`.

Each machine has its own SSH key in `hosts/<machine>/secrets.yaml`, placed at `~/.ssh/id_ed25519` and authorised once on GitHub and the homeserver (`user` and `git`). A reinstall decrypts the same key, so nothing needs authorising again. To revoke a machine, remove its key from GitHub and the homeserver's `authorized_keys`.

On NixOS the Obsidian vault syncs to `homeserver-git:/zfs-pool/git/francis-notes.git` through `services.git-sync` (`home/vault.nix`): it sets the vault up on first login, commits and pushes on every change, and pulls every 500 seconds when idle. Failures after setup are silent, so check `journalctl --user -u git-sync-personal` if notes stop arriving.

Repos listed in `home/repos.nix` are cloned into `~/dev` on login, if missing, by the `clone-repos` user service. Existing checkouts are never touched; `mr status` shows uncommitted work across all of them.

The homeserver's Samba shares `francis` and `shared` mount on first access under `/mnt/homeserver/`, with the login from the `samba-credentials` secret. The workstation reaches the homeserver over the LAN only.

On a new NixOS machine, copy the key from Bitwarden to `/var/lib/sops-nix/key.txt` (root-owned, mode `600`) before the first boot. Without it, nothing decrypts and `francis` cannot log in.

## Development

```bash
nix develop     # or just cd in, if direnv is set up
pnpm install    # once per clone; commit-msg needs commitlint from node_modules
```

The shell brings the linters and `pnpm`, and installs the git hooks:

| Stage | Runs |
|---|---|
| `pre-commit` | `nixfmt`, `statix`, `deadnix` |
| `commit-msg` | `commitlint` |
| `pre-push` | `nix flake check` |

`nix flake check` builds the Home Manager config and evaluates the NixOS one. It is on push rather than commit because it is much heavier than the linters, and committing should stay fast.

Commits follow Conventional Commits with a leading gitmoji, subject line only — `commitlint.config.mjs` is the authority, and the `commit-msg` hook enforces it.

## Conventions

Each `home/*.nix` module owns one concern and is imported by `common.nix`, except the `linux.nix` entry point, which imports `common.nix`. Adding a tool means a new file there plus one line in the import list, not a section appended to an existing module.

System-level config shared by NixOS hosts goes in `hosts/common.nix`, and anything specific to one host goes in `hosts/<name>/configuration.nix`.

Config is transcribed into Nix options rather than copied verbatim — `programs.starship.settings` as an attrset, not `readFile` on a TOML file. Typed options catch mistakes at build time and Home Manager handles the ordering constraints, so prefer a module over `home.file` whenever one exists.
