{ ... }:
{
  imports = [
    ./agent.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./packages.nix
    ./shell.nix
    ./starship.nix
  ];

  home = {
    username = "francis";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
