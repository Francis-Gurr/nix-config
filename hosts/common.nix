{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ./update.nix ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Keep kernel errors off the tty, where they overwrite tuigreet's fields; they stay in the journal.
  boot.consoleLogLevel = 3;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";

  networking.networkmanager = {
    enable = true;
    # Declared so a fresh install joins Wi-Fi on its own; the PSK comes from sops.
    ensureProfiles = {
      environmentFiles = [ config.sops.secrets.wifi-env.path ];
      profiles.Camelot = {
        connection = {
          id = "Camelot";
          type = "wifi";
        };
        wifi.ssid = "Camelot";
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$WIFI_PSK";
        };
      };
    };
  };
  security = {
    rtkit.enable = true;
    # Unlock the keyring with the login password.
    pam.services.greetd.enableGnomeKeyring = true;
  };

  programs = {
    # Pinned so an unattended clone never stops at "Host key verification failed".
    ssh.knownHosts."github.com".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    zsh.enable = true;
    hyprland.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  services = {
    # Device firmware from LVFS; the `update` command applies it.
    fwupd.enable = true;
    # Secret Service for app login tokens; without it Electron apps store them under a fixed key.
    gnome.gnome-keyring.enable = true;
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
      # Each host sets sopsFile to its own key.
      ssh-key = {
        owner = "francis";
        path = "/home/francis/.ssh/id_ed25519";
      };
      wifi-env = { };
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
