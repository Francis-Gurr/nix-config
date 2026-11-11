{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";

  networking.networkmanager.enable = true;
  security.rtkit.enable = true;

  programs = {
    zsh.enable = true;
    hyprland.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
    };
  };

  # Set explicitly because programs.steam is the only other definition.
  hardware.graphics.enable = true;

  sops = {
    defaultSopsFile = ../secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      francis-password.neededForUsers = true;
      samba-credentials = { };
    };
  };

  fileSystems = import ./homeserver-mounts.nix { inherit config lib; };

  # sops-nix would otherwise create ~/.ssh as root when placing the SSH key.
  systemd.tmpfiles.rules = [ "d /home/francis/.ssh 0700 francis users -" ];

  users = {
    mutableUsers = false;
    users.francis = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.francis-password.path;
    };
  };

  system.stateVersion = "26.05";
}
