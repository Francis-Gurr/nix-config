{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Vault name → bare repo on the homeserver; each syncs to ~/notes/<name>.
  vaults = {
    personal = "francis-notes";
    shared = "shared-notes";
  };

  path = name: "${config.home.homeDirectory}/notes/${name}";
  uri = repo: "homeserver-git:/zfs-pool/git/${repo}.git";

  # git-sync only clones into a missing directory, but programs.obsidian has already written
  # .obsidian/ here. Check out beside it and move .git in last, so a run cut short leaves
  # nothing behind and the next start retries.
  setupInPlace =
    name: repo:
    pkgs.writeShellScript "git-sync-${name}-setup" ''
      set -eu
      export PATH=${lib.makeBinPath [ pkgs.coreutils ]}:$PATH
      vault=${lib.escapeShellArg (path name)}
      [ -d "$vault/.git" ] && exit 0
      tmp=$(mktemp -d)
      git clone --no-checkout ${lib.escapeShellArg (uri repo)} "$tmp"
      mkdir -p "$vault"
      git --git-dir="$tmp/.git" --work-tree="$vault" reset --hard --quiet
      # git-sync-on-inotify reads the remote from here.
      git --git-dir="$tmp/.git" config branch.main.pushRemote origin
      mv "$tmp/.git" "$vault/.git"
      rmdir "$tmp"
    '';
in
{
  services.git-sync = {
    enable = true;
    repositories = lib.mapAttrs (name: repo: {
      path = path name;
      uri = uri repo;
    }) vaults;
  };

  systemd.user.services = lib.mapAttrs' (
    name: repo:
    lib.nameValuePair "git-sync-${name}" {
      Service = {
        ExecStartPre = "${setupInPlace name repo}";
        # The module's on-abort never retries a clone that failed at login.
        Restart = lib.mkForce "on-failure";
        RestartSec = "1min";
        Environment = [ "GIT_SSH_COMMAND=ssh -o ConnectTimeout=10" ];
      };
    }
  ) vaults;
}
