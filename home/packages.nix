{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    btop
    fd
    gh
    jq
    nerd-fonts.fira-code
    ripgrep
  ];

  fonts.fontconfig.enable = true;
}
