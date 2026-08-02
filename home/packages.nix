{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    btop
    fd
    gh
    nerd-fonts.fira-code
    ripgrep
  ];

  fonts.fontconfig.enable = true;
}
