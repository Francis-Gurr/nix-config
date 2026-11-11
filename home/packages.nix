{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    bitwarden-desktop
    claude-desktop
    btop
    fd
    gh
    jq
    nerd-fonts.fira-code
    ripgrep
  ];

  fonts.fontconfig.enable = true;
}
