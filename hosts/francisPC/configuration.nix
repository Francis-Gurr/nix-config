{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "francisPC";

  # Already authorised on GitHub and the homeserver; the VM rehearsed with it.
  sops.secrets.ssh-key.sopsFile = ./secrets.yaml;

  boot.loader = {
    # Windows and Fedora are reached through F8, so the menu only lists generations; hold Space for it.
    timeout = 0;
    systemd-boot = {
      enable = true;
      # The 600M ESP is shared with Fedora and holds every generation's kernel.
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  # The Xbox controller dongle; without it, mt76x2u claims the dongle as a Wi-Fi card.
  hardware.xone.enable = true;

  # Windows keeps the hardware clock in local time.
  time.hardwareClockInLocalTime = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
