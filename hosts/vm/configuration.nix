{ config, lib, ... }:
let
  # vmWithBootLoader does not inherit vmVariant, so both need the same settings.
  vmSettings = {
    memorySize = 8192;
    cores = 6;
    diskSize = 40960;
    # The default tmpfs store loses everything built in the VM at shutdown.
    writableStoreUseTmpfs = false;
    # qemu-vm.nix replaces the host's fileSystems, so the shares are added again here.
    fileSystems = import ../homeserver-mounts.nix { inherit config lib; };
    qemu.options = [
      # QEMU's default is 1280x800, which Hyprland takes as the preferred mode.
      "-device virtio-vga-gl,xres=2560,yres=1440"
      "-display gtk,gl=on"
    ];
  };
in
{
  imports = [ ../common.nix ];

  # nix flake check evaluates the real system, which needs a root filesystem
  # and a bootloader even though the VM variant replaces both.
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  boot.loader.systemd-boot.enable = true;

  sops = {
    # The VM reads a copy of the host's age key from $SHARED_DIR, so wiping the disk loses nothing.
    age.keyFile = lib.mkForce "/tmp/shared/keys.txt";
    # The VM rehearses francisPC, so it uses that machine's key.
    secrets.ssh-key = {
      sopsFile = ../francisPC/secrets.yaml;
      owner = "francis";
      path = "/home/francis/.ssh/id_ed25519";
    };
  };

  # QEMU's DNS gives the guest no search domain, and the router only answers homeserver.localdomain.
  networking.search = [ "localdomain" ];

  virtualisation = {
    vmVariant.virtualisation = vmSettings;
    vmVariantWithBootLoader.virtualisation = vmSettings;
  };
}
