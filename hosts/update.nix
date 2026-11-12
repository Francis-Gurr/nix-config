{ config, pkgs, ... }:
let
  flake = "${config.users.users.francis.home}/dev/nix-config";

  update = pkgs.writeShellApplication {
    name = "update";
    runtimeInputs = [
      config.nix.package
      config.programs.nh.package
      config.services.fwupd.package
      pkgs.git
      pkgs.jq
    ];
    text = ''
      cd ${flake}
      if [[ -n $(git status --porcelain) ]]; then
        echo "update: ${flake} has uncommitted changes; commit or stash them first." >&2
        exit 1
      fi
      git pull --ff-only

      # nh exits non-zero when the build fails or the diff is declined; keep the old pins then.
      if ! nh os switch --update --ask; then
        git restore flake.lock
        exit 1
      fi
      if ! git diff --quiet flake.lock; then
        # Name the inputs that moved, falling back to a count so the header stays under commitlint's 100 characters.
        changed=$(git show HEAD:flake.lock | jq --raw-output --slurpfile new flake.lock '
          .nodes as $old | $new[0].nodes.root.inputs as $inputs
          | [$inputs | to_entries[] | select($old[.value].locked.narHash != $new[0].nodes[.value].locked.narHash) | .key]
          | if length == ($inputs | length) then "all inputs"
            elif (join(", ") | length) > 70 then "\(length) inputs"
            else join(", ") end')
        # The dev shell provides the commit hooks' tools.
        nix develop --command git commit --message "📦️ build(flake): update $changed" flake.lock
        nix develop --command git push
      fi

      # Exit code 2 means "nothing to do". Firmware needing a reboot installs at the next one.
      fwupdmgr refresh || [[ $? -eq 2 ]]
      fwupdmgr update --assume-yes --no-reboot-check || [[ $? -eq 2 ]]
    '';
  };
in
{
  programs.nh = {
    enable = true;
    inherit flake;
    clean = {
      enable = true;
      # Age alone could delete every rollback point after a month without updates.
      extraArgs = "--keep 5 --keep-since 30d";
    };
  };

  environment.systemPackages = [ update ];
}
