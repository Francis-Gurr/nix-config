{
  programs.starship = {
    enable = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      command_timeout = 10000;

      format = "$username$hostname$localip$shlvl$directory$git_branch$git_commit$git_state$git_status$fill\${custom.config_branch}$line_break$character";

      directory.truncation_length = 50;

      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };

      git_state.style = "bright-black";

      # untracked/modified/renamed/deleted are a zero-width space, not an empty
      # string: non-empty makes the literal `*` render, invisible keeps it silent.
      git_status = {
        format = "[[(*$untracked$modified$renamed$deleted)](white)  ($conflicted )($staged )($ahead_behind )($stashed)]($style)";
        style = "dimmed bright-black";
        ahead = "[↑](dimmed white)\${count}";
        behind = "[↓](dimmed white)\${count}";
        diverged = "[⇅](dimmed white)\${count}";
        conflicted = "[✕](dimmed white)\${count}";
        untracked = "​";
        modified = "​";
        staged = "[+](dimmed white)\${count}";
        renamed = "​";
        deleted = "​";
        stashed = "[≡](dimmed white)\${count}";
      };

      fill.symbol = " ";

      # Surfaces a half-finished config change in every prompt, on any machine.
      custom.config_branch = {
        command = ''
          branch=$(git -C $HOME/dev/nix-config branch --show-current 2>/dev/null)
          if [ "$branch" != "main" ]; then
            echo "$branch"
          fi
        '';
        when = true;
        format = "[$output]($style) ";
        style = "dimmed white";
      };
    };
  };
}
