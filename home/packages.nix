{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    bitwarden-desktop
    # The FHS env runs the claude binary, MCP servers and Cowork VM the app downloads.
    claude-desktop-fhs
    btop
    fd
    gh
    jq
    nerd-fonts.fira-code
    python3
    ripgrep
  ];

  fonts.fontconfig.enable = true;
}
