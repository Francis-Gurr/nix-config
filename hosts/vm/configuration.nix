let
  # vmWithBootLoader does not inherit vmVariant, so both need the same settings.
  vmSettings = {
    memorySize = 8192;
    cores = 6;
    diskSize = 40960;
    # The default tmpfs store loses everything built in the VM at shutdown.
    writableStoreUseTmpfs = false;
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

  virtualisation = {
    vmVariant.virtualisation = vmSettings;
    vmVariantWithBootLoader.virtualisation = vmSettings;
  };
}
