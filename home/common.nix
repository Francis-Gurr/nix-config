{ ... }:
{
  imports = [
    ./agent.nix
    ./firefox.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./obsidian.nix
    ./packages.nix
    ./shell.nix
    ./ssh.nix
    ./starship.nix
    ./vscode.nix
  ];

  home = {
    username = "francis";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
