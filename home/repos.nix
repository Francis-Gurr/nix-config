{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.mr = {
    enable = true;
    settings = {
      "dev/nix-config".checkout = "git clone git@github.com:Francis-Gurr/nix-config.git";
      "dev/homeserver-ansible".checkout = "git clone git@github.com:Francis-Gurr/homeserver-ansible.git";
    };
  };

  # Clone anything missing at login. Retries while the network or server is down.
  systemd.user.services.clone-repos = {
    Unit.Description = "Clone missing repos from ~/.mrconfig";
    Service = {
      Type = "oneshot";
      ExecStart = "${lib.getExe config.programs.mr.package} checkout";
      Environment = [
        # mr runs mkdir to create ~/dev, so coreutils is needed too.
        "PATH=${
          lib.makeBinPath [
            pkgs.coreutils
            pkgs.git
            pkgs.openssh
          ]
        }"
        # Fail fast when the network is down, rather than after the kernel's ~2 min.
        "GIT_SSH_COMMAND=ssh -o ConnectTimeout=10"
      ];
      Restart = "on-failure";
      RestartSec = "1min";
    };
    Install.WantedBy = [ "default.target" ];
  };
}
