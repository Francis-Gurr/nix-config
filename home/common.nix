{ pkgs, ... }:
{
  home = {
    username = "francis";
    stateVersion = "26.05";
    packages = [ pkgs.ripgrep ];
  };

  programs.home-manager.enable = true;
}
