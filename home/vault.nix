{
  config,
  lib,
  pkgs,
  ...
}:
let
  path = "${config.home.homeDirectory}/notes/personal";
  uri = "homeserver-git:/zfs-pool/git/francis-notes.git";

  # git-sync only clones into a missing directory, but programs.obsidian has already written
  # .obsidian/ here. Check out beside it and move .git in last, so a run cut short leaves
  # nothing behind and the next start retries.
  setupInPlace = pkgs.writeShellScript "git-sync-personal-setup" ''
    set -eu
    export PATH=${lib.makeBinPath [ pkgs.coreutils ]}:$PATH
    vault=${lib.escapeShellArg path}
    [ -d "$vault/.git" ] && exit 0
    tmp=$(mktemp -d)
    git clone --no-checkout ${lib.escapeShellArg uri} "$tmp"
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
    repositories.personal = { inherit path uri; };
  };

  systemd.user.services.git-sync-personal.Service = {
    ExecStartPre = "${setupInPlace}";
    # The module's on-abort never retries a clone that failed at login.
    Restart = lib.mkForce "on-failure";
    RestartSec = "1min";
    Environment = [ "GIT_SSH_COMMAND=ssh -o ConnectTimeout=10" ];
  };
}
