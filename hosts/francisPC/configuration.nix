{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "francisPC";

  # Already authorised on GitHub and the homeserver; the VM rehearsed with it.
  sops.secrets.ssh-key.sopsFile = ./secrets.yaml;

  boot.loader = {
    systemd-boot = {
      enable = true;
      # The 600M ESP is shared with Fedora and holds every generation's kernel.
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  # Windows keeps the hardware clock in local time.
  time.hardwareClockInLocalTime = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
}
