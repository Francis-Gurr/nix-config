{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  home = {
    homeDirectory = "/home/francis";

    packages = with pkgs; [
      imv
      wl-clipboard
    ];
  };
}
