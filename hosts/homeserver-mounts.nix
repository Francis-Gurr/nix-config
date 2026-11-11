# Separate file because the VM needs these twice: qemu-vm.nix replaces the host's fileSystems.
{ config, lib }:
lib.genAttrs [ "/mnt/homeserver/francis" "/mnt/homeserver/shared" ] (mountPoint: {
  device = "//homeserver/${baseNameOf mountPoint}";
  fsType = "cifs";
  options = [
    "credentials=${config.sops.secrets.samba-credentials.path}"
    "uid=1000"
    "gid=100"
    # Mount on first access, so a server that is down cannot stall boot.
    "noauto"
    "x-systemd.automount"
    "x-systemd.idle-timeout=60"
    "x-systemd.mount-timeout=5s"
  ];
})
