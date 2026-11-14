{ lib, pkgs, ... }:
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
      # lanzaboote replaces it, and inherits configurationLimit.
      enable = lib.mkForce false;
      # The 600M ESP is shared with Fedora and holds every generation's kernel.
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
  };

  # Secure Boot, which some Windows games require; signs each generation with keys from `sbctl create-keys`.
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  environment.systemPackages = [ pkgs.sbctl ];

  # The Xbox controller dongle; without it, mt76x2u claims the dongle as a Wi-Fi card.
  hardware.xone.enable = true;

  # The MT7922 card's Bluetooth; the VM has no adapter, so this stays per host.
  hardware.bluetooth.enable = true;
  # Its tray applet starts from XDG autostart, which UWSM runs.
  services.blueman.enable = true;

  # Windows keeps the hardware clock in local time.
  time.hardwareClockInLocalTime = true;
}
