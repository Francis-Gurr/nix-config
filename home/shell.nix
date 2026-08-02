{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      lsd
      zsh-completions
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };

    sessionPath = [
      "$HOME/.local/share/pnpm/bin"
      "$HOME/.local/bin"
    ];
  };

  programs = {
    zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      history = {
        size = 100000;
        save = 100000;
        extended = true;
        expireDuplicatesFirst = true;
        findNoDups = true;
        ignoreDups = true;
        ignoreSpace = true;
        saveNoDups = true;
        share = true;
      };

      shellAliases = {
        ls = "lsd";
        gco = "git checkout";
        g = "git status";
        gd = "git diff";
        gds = "git diff --staged";
        ga = "git add";
        gaa = "git add --all";
        gap = "git add --patch";
        gc = "git commit";
        gca = "git commit --amend";
        gcane = "git commit --amend --no-edit";
        gp = "git push";
        gpf = "git push --force-with-lease";
        gs = "git stash";
        gsp = "git stash pop";
      };

      initContent = ''
        gcm() {
          git commit -m "$1"
        }
      '';
    };

    fzf.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
