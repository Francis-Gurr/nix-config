{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./shell.nix
    ./starship.nix
  ];

  home = {
    username = "francis";
    stateVersion = "26.05";
    packages = [ pkgs.ripgrep ];
  };

  programs.home-manager.enable = true;
}
